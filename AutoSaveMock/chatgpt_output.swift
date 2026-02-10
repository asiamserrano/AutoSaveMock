/*

File: chatgpt_output.swift
Purpose: Non-invasive, fully-commented reference implementation for two-way conversion between Property.Builder and Attribute.Builder, focusing only on builders (ignore models). All content is wrapped in a block comment to avoid impacting the build.

Assumptions based on your codebase hints:
- Generic.swift defines Generic.Model.Builder and Generic.Attribute.Builder cases.
- Property+Model.swift defines Property.Builder with cases: input(InputBuilder), mode(ModeEnum), system(SystemBuilder), format(FormatBuilder).
- Attribute side has builder cases: input(InputBuilder), mode(ModeEnum), platform(PlatformBuilder) where PlatformBuilder composes (SystemBuilder, FormatBuilder).
- Enumerations like ModeEnum, and builder wrappers like SystemBuilder/FormatBuilder expose identity (id), rawValue/yoke as needed elsewhere.

If your actual names differ slightly, adjust the typealiases near the top of this block for a single point of change.

--------------------------------------------------------------------------------
Typealiases to anchor names used below
--------------------------------------------------------------------------------
*/

/*
 
 // Update these aliases if your project uses different concrete names.
 typealias PropertyBuilder = Property.Builder
 // Example: enum Generic.Attribute.Builder { case input(InputBuilder), mode(ModeEnum), platform(PlatformBuilder) }
 typealias AttributeBuilder = Generic.Attribute.Builder

 // These builder types are referenced by Property.Builder in your code.
 // They should already exist in your project. If their names differ, change here.
 typealias InputBuilder = Property.InputBuilder
 typealias SystemBuilder = Property.SystemBuilder
 typealias FormatBuilder = Property.FormatBuilder

 typealias ModeEnum = ModeEnum // keep as-is if this is the real name

 // A composite builder for Attribute.Platform. If you already have one, use it.
 // Otherwise, this is a reference shape describing what is expected.
 struct PlatformBuilder: Hashable {
     let system: SystemBuilder
     let format: FormatBuilder
 }

 // MARK: - Canonical, explicit mappings between Property.Builder and Attribute.Builder

 enum AttributePropertyMapper {

     // MARK: Property -> Attribute
     // Property: input, mode, system, format
     // Attribute: input, mode, platform(system, format)

     static func toAttribute(_ p: PropertyBuilder) -> AttributeBuilder? {
         switch p {
         case .input(let input):
             return .input(input)
         case .mode(let mode):
             return .mode(mode)
         case .system(let system):
             // Requires a format to form a platform. Without context, cannot be losslessly mapped.
             // Return nil to indicate incomplete information.
             return nil
         case .format(let format):
             // Requires a system to form a platform. Without context, cannot be losslessly mapped.
             // Return nil to indicate incomplete information.
             return nil
         }
     }

     // Property (system + format) -> Attribute (platform)
     // This overload accepts both parts explicitly to build a platform.
     static func toAttributePlatform(system: SystemBuilder, format: FormatBuilder) -> AttributeBuilder {
         let platform = PlatformBuilder(system: system, format: format)
         return .platform(platform)
     }

     // MARK: Attribute -> Property
     // Attribute: input, mode, platform(system, format)
     // Property: input, mode, system, format

     static func toProperty(_ a: AttributeBuilder) -> [PropertyBuilder] {
         switch a {
         case .input(let input):
             return [.input(input)]
         case .mode(let mode):
             return [.mode(mode)]
         case .platform(let platform):
             return [.system(platform.system), .format(platform.format)]
         }
     }
 }

 // MARK: - Ergonomic convenience APIs
 // These helpers make call sites concise and explicit. They avoid any guessing.

 extension PropertyBuilder {
     // Convert a single property builder to attribute when possible.
     // Returns nil for system/format alone because those require pairing to form a platform.
     var asAttributeIfLossless: AttributeBuilder? {
         AttributePropertyMapper.toAttribute(self)
     }
 }

 extension AttributeBuilder {
     // Expand an attribute builder into one or more property builders.
     var asPropertyBuilders: [PropertyBuilder] {
         AttributePropertyMapper.toProperty(self)
     }
 }

 // MARK: - Explicit construction helpers for platform
 // When you have separate system and format builders and need an Attribute platform.

 struct AttributePlatformFactory {
     static func make(system: SystemBuilder, format: FormatBuilder) -> AttributeBuilder {
         AttributePropertyMapper.toAttributePlatform(system: system, format: format)
     }
 }
 */

// MARK: - Worked examples (non-executable comments)
//
// let pInput: PropertyBuilder = .input(InputBuilder.someCase)
// let aInput = pInput.asAttributeIfLossless // => .input(...)
//
// let pMode: PropertyBuilder = .mode(.someMode)
// let aMode = pMode.asAttributeIfLossless // => .mode(...)
//
// let pSystem: PropertyBuilder = .system(SystemBuilder.someSystem)
// let aFromSystem = pSystem.asAttributeIfLossless // => nil (needs format)
//
// let pFormat: PropertyBuilder = .format(FormatBuilder.someFormat)
// let aFromFormat = pFormat.asAttributeIfLossless // => nil (needs system)
//
// let platform = AttributePlatformFactory.make(system: .someSystem, format: .someFormat)
// let propertyParts = platform.asPropertyBuilders // => [.system(.someSystem), .format(.someFormat)]
//
// End of reference implementation.

