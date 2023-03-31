"
A VZEdgeGlyphTest is a test class for testing the behavior of VZEdgeGlyph
"
Class {
	#name : #VZEdgeGlyphTest,
	#superclass : #VZTestCase,
	#instVars : [
		'view',
		'edgeGlyph',
		'edge'
	],
	#category : #'Vizor-GUI-Tests-Glyphs'
}

{ #category : #running }
VZEdgeGlyphTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	view := VZView exampleForTests.
	edge := view edges first.
	edgeGlyph := edge glyph.
]

{ #category : #tests }
VZEdgeGlyphTest >> testColor [
	self assert: edgeGlyph color equals: Color black.
]

{ #category : #tests }
VZEdgeGlyphTest >> testEntity [
	self assert: edgeGlyph entity equals: edge.
]

{ #category : #tests }
VZEdgeGlyphTest >> testSetPropertiesForGlyph [
	edgeGlyph shape: edgeGlyph shapeForRoassal.
	edgeGlyph setPropertiesForGlyph.
	
	self assert: edgeGlyph shape isNotNil.
	self assert: edgeGlyph shape model equals: edgeGlyph.
]

{ #category : #tests }
VZEdgeGlyphTest >> testShape [
	self assert: edgeGlyph shape isNil.
]

{ #category : #tests }
VZEdgeGlyphTest >> testShapeForRoassal [
	| shape |
	shape := edgeGlyph shapeForRoassal.
	
	self assert: shape isNotNil.
	self assert: shape class equals: RSLine.
]

{ #category : #tests }
VZEdgeGlyphTest >> testView [
	"The view should be assigned explicitly, this only happens in the render method of the view."
	self assert: edgeGlyph view isNil.
]

{ #category : #tests }
VZEdgeGlyphTest >> testWidth [
	self assert: edgeGlyph width equals: 1.
]
