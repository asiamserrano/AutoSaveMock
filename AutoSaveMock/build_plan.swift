//
//  build_plan.swift
//  AutoSaveMock
//
//  Created by ChatGPT on request.
//
//  This file introduces a non-invasive build plan/orchestrator for creating
//  Properties, Platforms, and Attributes in a dependency-aware, idempotent way.
//  It does not modify any existing files. Wire it to your repositories/services
//  by implementing the small persistence protocol stubs below.
//

import Foundation

// MARK: - Stable identity protocol for deduplication

public protocol StableIdentifiable {
    var stableID: String { get }
}

// MARK: - Intent graph (what to create)

public enum BuildIntent: Hashable {
    // Terminal leaves
    case system(SystemBuilderID)
    case format(FormatBuilderID)
    case propertyInput(InputBuilderID)
    case propertyMode(ModeEnumID)

    // Composite nodes
    case propertySystem(SystemBuilderID)
    case propertyFormat(FormatBuilderID)
    case platform(system: SystemBuilderID, format: FormatBuilderID)

    // Attribute nodes
    case attributeInput(InputBuilderID)
    case attributeMode(ModeEnumID)
    case attributePlatform(system: SystemBuilderID, format: FormatBuilderID)
}

// MARK: - Lightweight IDs decoupled from concrete builders
// Adjust mapping in the adapter layer below if your actual builders expose different identifiers.

public struct SystemBuilderID: Hashable, StableIdentifiable { public let stableID: String }
public struct FormatBuilderID: Hashable, StableIdentifiable { public let stableID: String }
public struct InputBuilderID: Hashable, StableIdentifiable { public let stableID: String }
public struct ModeEnumID: Hashable, StableIdentifiable { public let stableID: String }

// MARK: - Persistence adapter protocol (plug in your repositories here)

public protocol BuildPersistenceAdapter {
    // Existence checks / fetches by stableID
    func fetchSystem(by id: SystemBuilderID) -> Any?
    func fetchFormat(by id: FormatBuilderID) -> Any?
    func fetchPropertySystem(by id: SystemBuilderID) -> Any?
    func fetchPropertyFormat(by id: FormatBuilderID) -> Any?
    func fetchPropertyInput(by id: InputBuilderID) -> Any?
    func fetchPropertyMode(by id: ModeEnumID) -> Any?
    func fetchPlatform(system: SystemBuilderID, format: FormatBuilderID) -> Any?
    func fetchAttributeInput(by id: InputBuilderID) -> Any?
    func fetchAttributeMode(by id: ModeEnumID) -> Any?
    func fetchAttributePlatform(system: SystemBuilderID, format: FormatBuilderID) -> Any?

    // Creation operations (return created instances if desired)
    @discardableResult func ensureSystem(id: SystemBuilderID) -> Any
    @discardableResult func ensureFormat(id: FormatBuilderID) -> Any
    @discardableResult func ensurePropertySystem(id: SystemBuilderID) -> Any
    @discardableResult func ensurePropertyFormat(id: FormatBuilderID) -> Any
    @discardableResult func ensurePropertyInput(id: InputBuilderID) -> Any
    @discardableResult func ensurePropertyMode(id: ModeEnumID) -> Any
    @discardableResult func ensurePlatform(system: SystemBuilderID, format: FormatBuilderID) -> Any
    @discardableResult func ensureAttributeInput(id: InputBuilderID) -> Any
    @discardableResult func ensureAttributeMode(id: ModeEnumID) -> Any
    @discardableResult func ensureAttributePlatform(system: SystemBuilderID, format: FormatBuilderID) -> Any
}

// MARK: - Build Plan

public struct BuildPlan {
    public private(set) var intents: Set<BuildIntent> = []

    public init() {}

    // Seed with Property builders
    public mutating func add(propertyInput id: InputBuilderID) {
        intents.insert(.propertyInput(id))
        intents.insert(.attributeInput(id)) // optional: attribute mirrors property
    }

    public mutating func add(propertyMode id: ModeEnumID) {
        intents.insert(.propertyMode(id))
        intents.insert(.attributeMode(id)) // optional: attribute mirrors property
    }

    public mutating func add(propertySystem id: SystemBuilderID) {
        intents.insert(.system(id))
        intents.insert(.propertySystem(id))
    }

    public mutating func add(propertyFormat id: FormatBuilderID) {
        intents.insert(.format(id))
        intents.insert(.propertyFormat(id))
    }

    // Seed with Attribute builders
    public mutating func add(attributeInput id: InputBuilderID) {
        intents.insert(.attributeInput(id))
        intents.insert(.propertyInput(id)) // mirror to property
    }

    public mutating func add(attributeMode id: ModeEnumID) {
        intents.insert(.attributeMode(id))
        intents.insert(.propertyMode(id)) // mirror to property
    }

    public mutating func add(attributePlatform system: SystemBuilderID, format: FormatBuilderID) {
        intents.insert(.attributePlatform(system: system, format: format))
        // Expand to dependencies
        intents.insert(.system(system))
        intents.insert(.format(format))
        intents.insert(.propertySystem(system))
        intents.insert(.propertyFormat(format))
        intents.insert(.platform(system: system, format: format))
    }

    // MARK: Order of execution phases (DAG-friendly)

    public enum Phase: Int, CaseIterable {
        case systemsAndFormats = 0
        case propertiesSystemAndFormat
        case platform
        case propertiesInputAndMode
        case attributes
    }

    public func intents(for phase: Phase) -> [BuildIntent] {
        switch phase {
        case .systemsAndFormats:
            return intents.filter { intent in
                switch intent {
                case .system, .format: return true
                default: return false
                }
            }.sorted(by: sort)
        case .propertiesSystemAndFormat:
            return intents.filter { intent in
                switch intent {
                case .propertySystem, .propertyFormat: return true
                default: return false
                }
            }.sorted(by: sort)
        case .platform:
            return intents.filter { intent in
                if case .platform = intent { return true } else { return false }
            }.sorted(by: sort)
        case .propertiesInputAndMode:
            return intents.filter { intent in
                switch intent {
                case .propertyInput, .propertyMode: return true
                default: return false
                }
            }.sorted(by: sort)
        case .attributes:
            return intents.filter { intent in
                switch intent {
                case .attributeInput, .attributeMode, .attributePlatform: return true
                default: return false
                }
            }.sorted(by: sort)
        }
    }

    // Deterministic ordering for stable processing/logging
    private func sort(_ lhs: BuildIntent, _ rhs: BuildIntent) -> Bool {
        lhs.description < rhs.description
    }
}

// MARK: - BuildIntent printable identity

extension BuildIntent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .system(let id): return "system(\(id.stableID))"
        case .format(let id): return "format(\(id.stableID))"
        case .propertyInput(let id): return "propertyInput(\(id.stableID))"
        case .propertyMode(let id): return "propertyMode(\(id.stableID))"
        case .propertySystem(let id): return "propertySystem(\(id.stableID))"
        case .propertyFormat(let id): return "propertyFormat(\(id.stableID))"
        case .platform(let s, let f): return "platform(\(s.stableID),\(f.stableID))"
        case .attributeInput(let id): return "attributeInput(\(id.stableID))"
        case .attributeMode(let id): return "attributeMode(\(id.stableID))"
        case .attributePlatform(let s, let f): return "attributePlatform(\(s.stableID),\(f.stableID))"
        }
    }
}

// MARK: - Orchestrator

public final class BuildOrchestrator {
    private let adapter: BuildPersistenceAdapter

    // In-run cache to avoid redundant fetches/creates during this orchestration
    private var seen: Set<String> = []

    public init(adapter: BuildPersistenceAdapter) {
        self.adapter = adapter
    }

    // Execute plan in phases. Each ensure* call should be idempotent and backed by query-first semantics in the adapter.
    public func execute(plan: BuildPlan) {
        for phase in BuildPlan.Phase.allCases {
            for intent in plan.intents(for: phase) {
                process(intent)
            }
        }
    }

    private func process(_ intent: BuildIntent) {
        let key = intent.description
        guard !seen.contains(key) else { return }
        seen.insert(key)

        switch intent {
        case .system(let id):
            _ = adapter.fetchSystem(by: id) ?? adapter.ensureSystem(id: id)

        case .format(let id):
            _ = adapter.fetchFormat(by: id) ?? adapter.ensureFormat(id: id)

        case .propertySystem(let id):
            // Depends on system
            _ = adapter.fetchSystem(by: id) ?? adapter.ensureSystem(id: id)
            _ = adapter.fetchPropertySystem(by: id) ?? adapter.ensurePropertySystem(id: id)

        case .propertyFormat(let id):
            // Depends on format
            _ = adapter.fetchFormat(by: id) ?? adapter.ensureFormat(id: id)
            _ = adapter.fetchPropertyFormat(by: id) ?? adapter.ensurePropertyFormat(id: id)

        case .platform(let system, let format):
            // Depends on system + format
            _ = adapter.fetchSystem(by: system) ?? adapter.ensureSystem(id: system)
            _ = adapter.fetchFormat(by: format) ?? adapter.ensureFormat(id: format)
            _ = adapter.fetchPlatform(system: system, format: format) ?? adapter.ensurePlatform(system: system, format: format)

        case .propertyInput(let id):
            _ = adapter.fetchPropertyInput(by: id) ?? adapter.ensurePropertyInput(id: id)

        case .propertyMode(let id):
            _ = adapter.fetchPropertyMode(by: id) ?? adapter.ensurePropertyMode(id: id)

        case .attributeInput(let id):
            // Depends on property input (optional, but recommended to keep consistent)
            _ = adapter.fetchPropertyInput(by: id) ?? adapter.ensurePropertyInput(id: id)
            _ = adapter.fetchAttributeInput(by: id) ?? adapter.ensureAttributeInput(id: id)

        case .attributeMode(let id):
            _ = adapter.fetchPropertyMode(by: id) ?? adapter.ensurePropertyMode(id: id)
            _ = adapter.fetchAttributeMode(by: id) ?? adapter.ensureAttributeMode(id: id)

        case .attributePlatform(let system, let format):
            // Depends on platform, which depends on system+format and their properties
            _ = adapter.fetchSystem(by: system) ?? adapter.ensureSystem(id: system)
            _ = adapter.fetchFormat(by: format) ?? adapter.ensureFormat(id: format)
            _ = adapter.fetchPropertySystem(by: system) ?? adapter.ensurePropertySystem(id: system)
            _ = adapter.fetchPropertyFormat(by: format) ?? adapter.ensurePropertyFormat(id: format)
            _ = adapter.fetchPlatform(system: system, format: format) ?? adapter.ensurePlatform(system: system, format: format)
            _ = adapter.fetchAttributePlatform(system: system, format: format) ?? adapter.ensureAttributePlatform(system: system, format: format)
        }
    }
}

// MARK: - Convenience factory to normalize input builders into IDs
// Implement these adapters where you can access your real builders.

public struct BuildInputNormalizer {
    public init() {}

    public func id(fromSystemBuilder builder: Any) -> SystemBuilderID {
        // Replace with real key extraction (e.g., builder.system.id)
        SystemBuilderID(stableID: String(describing: builder))
    }

    public func id(fromFormatBuilder builder: Any) -> FormatBuilderID {
        // Replace with real key extraction
        FormatBuilderID(stableID: String(describing: builder))
    }

    public func id(fromInputBuilder builder: Any) -> InputBuilderID {
        // Replace with real key extraction
        InputBuilderID(stableID: String(describing: builder))
    }

    public func id(fromModeEnum mode: Any) -> ModeEnumID {
        // Replace with real key extraction
        ModeEnumID(stableID: String(describing: mode))
    }
}

// MARK: - Example usage (pseudo-code)
//
// let adapter: BuildPersistenceAdapter = YourRepositoryAdapter()
// var plan = BuildPlan()
// let normalizer = BuildInputNormalizer()
//
// // From attribute platform
// let sysID = normalizer.id(fromSystemBuilder: platformBuilder.system)
// let fmtID = normalizer.id(fromFormatBuilder: platformBuilder.format)
// plan.add(attributePlatform: sysID, format: fmtID)
//
// // From property input
// let inputID = normalizer.id(fromInputBuilder: inputBuilder)
// plan.add(propertyInput: inputID)
//
// // Execute
// let orchestrator = BuildOrchestrator(adapter: adapter)
// orchestrator.execute(plan: plan)
//
