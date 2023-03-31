Class {
	#name : #VZGlyphTest,
	#superclass : #VZViewBasedTest,
	#instVars : [
		'nodeGlyph1',
		'nodeGlyph2',
		'nodeGlyph3',
		'nodeGlyph4',
		'baseGlyph'
	],
	#category : #'Vizor-GUI-Tests-Glyphs'
}

{ #category : #running }
VZGlyphTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	self flag: #FIXME. "This is a quick hack to fix tests, probably a cleaner way of testing the abstract class VZGlyph should be used (i.e. concrete implementation for testing)."
	baseGlyph := VZGlyph new
		entity: (VZEntity new model: 'My model');
		view: view.
	nodeGlyph1 := view findGlyphForNode: node1.
	nodeGlyph2 := view findGlyphForNode: node2.
	nodeGlyph3 := view findGlyphForNode: node3.
	nodeGlyph4 := view findGlyphForNode: node4.

]

{ #category : #tests }
VZGlyphTest >> testChangeColor [
	baseGlyph color: Color red.
	
	self assert: baseGlyph color equals: Color red.
]

{ #category : #tests }
VZGlyphTest >> testColor [
	self assert: baseGlyph color equals: baseGlyph class defaultColor.
]

{ #category : #tests }
VZGlyphTest >> testContextMenu [
	self assert: baseGlyph contextMenu isNotNil.
	self assert: (baseGlyph contextMenu isKindOf: SpMenuPresenter).
]

{ #category : #tests }
VZGlyphTest >> testDeselect [
	baseGlyph select.
	baseGlyph deselect.
	
	self deny: (view selection includes: baseGlyph).
]

{ #category : #tests }
VZGlyphTest >> testGetContext [
	| context |
	context := baseGlyph getContext.
	
	self assert: context isNotNil.
	self assert: context glyph equals: baseGlyph.
	self assert: context entity equals: baseGlyph entity.
	self assert: context view equals: view.
	self assert: context selection equals: view selection.
]

{ #category : #tests }
VZGlyphTest >> testPrettifyMenuName [
	| prettyString |
	prettyString := VZGlyph new prettifyMenuName: 'hide'.
	
	self assert: prettyString equals: 'Hide'
]

{ #category : #tests }
VZGlyphTest >> testPrettifyMenuName2 [
	| prettyString |
	prettyString := VZGlyph new prettifyMenuName: 'hideMethodName'.
	
	self assert: prettyString equals: 'Hide method name'
]

{ #category : #tests }
VZGlyphTest >> testPrettifyMenuName3 [
	| prettyString |
	prettyString := VZGlyph new prettifyMenuName: 'hide3MethodName'.
	
	self assert: prettyString equals: 'Hide3 method name'
]

{ #category : #tests }
VZGlyphTest >> testPrettifyMenuName4 [
	| prettyString |
	prettyString := VZGlyph new prettifyMenuName: 'hideMethodName4'.
	
	self assert: prettyString equals: 'Hide method name4'
]

{ #category : #tests }
VZGlyphTest >> testSelect [
	baseGlyph select.
	
	self assert: (view selection includes: baseGlyph).
]

{ #category : #tests }
VZGlyphTest >> testSelectAndHide [
	nodeGlyph1 select.
	
	self assert: (view selection entities includes: node1).
	view hide: node1.
	self assert: view selection isEmpty.
]

{ #category : #tests }
VZGlyphTest >> testSelectTwoAndHideOne [
	nodeGlyph1 select.
	nodeGlyph2 select.
	
	self assert: (view selection entities includesAll: { node1 . node2 }).
	nodeGlyph1 hide.
	self deny: (view selection entities includes: node1).
	self assert: (view selection entities includes: node2).
	
]

{ #category : #tests }
VZGlyphTest >> testToggleSelection [
	nodeGlyph1 toggleSelection.
	
	self assert: (view selection entities includes: node1).
]

{ #category : #tests }
VZGlyphTest >> testToggleSelection2 [
	nodeGlyph1 toggleSelection.
	nodeGlyph1 toggleSelection.
	
	self deny: (view selection entities includes: node1).
]

{ #category : #tests }
VZGlyphTest >> testToggleSelection3 [
	nodeGlyph1 toggleSelection.
	nodeGlyph1 toggleSelection.
	nodeGlyph1 toggleSelection.
	
	self assert: (view selection entities includes: node1).
]
