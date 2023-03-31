"
I represent an abstract glyph that can be rendered by a VZRenderer.

VZEntities contained in a VZView should have a method to return their VZGlyph so that the view can be rendered by the VZRenderer.

I know the entity I represent (a VZEntity), the view that contains me (a VZView).
I have a color and a shape.
I have a special property to where VZMetric can be mapped: devNull.
"
Class {
	#name : #VZGlyph,
	#superclass : #VZObject,
	#instVars : [
		'shape',
		'entity',
		'view',
		'color'
	],
	#category : #'Vizor-GUI-Glyphs'
}

{ #category : #constants }
VZGlyph class >> defaultColor [
	^ Color lightGray.
]

{ #category : #'instance creation' }
VZGlyph class >> of: aVZEntity [
	^ self subclassResponsibility
]

{ #category : #rendering }
VZGlyph >> afterRenderOn: aVZRenderer [
	"Override in subclasses if needed."
	^ self
]

{ #category : #rendering }
VZGlyph >> beforeRenderOn: aVZRenderer [
	"Override in subclasses if needed."
	^ self
]

{ #category : #accessing }
VZGlyph >> color [
	<vzProperty: #categorical>
	^ color
]

{ #category : #accessing }
VZGlyph >> color: aColor [
	color := aColor
]

{ #category : #interacting }
VZGlyph >> contextMenu [
	| aVZContext aMenu |
	aVZContext := self getContext.
	aMenu := SpMenuPresenter new.
	
	self fillContextMenu: aMenu inContext: aVZContext.
	self entity fillContextMenu: aMenu inContext: aVZContext.

	^ aMenu
]

{ #category : #copying }
VZGlyph >> copyPropertiesFrom: aVZGlyph [
	self shape: aVZGlyph shape copy.
	self color: aVZGlyph color copy.
]

{ #category : #selecting }
VZGlyph >> deselect [
	self view deselect: self.
]

{ #category : #accessing }
VZGlyph >> devNull [
	"Null property getter"
	^ nil
]

{ #category : #accessing }
VZGlyph >> devNull: aValue [
	"Null property setter, used to map metrics that are not displayed on any real glyph property but are tracked uniformly"
	^ self
]

{ #category : #accessing }
VZGlyph >> entity [
	^ entity
]

{ #category : #accessing }
VZGlyph >> entity: anObject [
	entity := anObject
]

{ #category : #interacting }
VZGlyph >> fillContextMenu: aMenu inContext: aVZContext [
	aMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item name: 'Hide';
					action: [ self hide ] ];
				addItem: [ :item |
					item name: 'Inspect';
					action: [ self inspect ] ] ].
]

{ #category : #interaction }
VZGlyph >> getContext [
	^ VZContext new
		glyph: self;
		entity: self entity;
		view: self view;
		selection: self view selection;
		yourself
]

{ #category : #interacting }
VZGlyph >> hide [
	self view hide: self; viewChanged.
]

{ #category : #initialization }
VZGlyph >> initialize [
	super initialize.
	color := self class defaultColor.
]

{ #category : #testing }
VZGlyph >> isSelected [
	^ self view selection includes: self.

]

{ #category : #accessing }
VZGlyph >> label [
	self entity model ifNotNil: [ :m | ^ m printString].
	^ self entity printString.
]

{ #category : #rendering }
VZGlyph >> mapMetricsToProperties [
	| mappings |
	mappings := self view findMetricMappingsForEntity: self entity.
	mappings do: [ :each | | metricClass attributeSetter value |
		metricClass := each key.
		attributeSetter := each value asMutator.
		value := metricClass value: self entity.
		self perform: attributeSetter with: value ].

]

{ #category : #interacting }
VZGlyph >> openContextMenu [
	self contextMenu openWithSpecAt: ActiveHand position
]

{ #category : #'private - utility' }
VZGlyph >> prettifyMenuName: name [
	"Capitalize first letter and split camelcase notation, to lowercase."
	| re |

	self flag: #FIXME "This handling is not a very robust beautifying when nonCamelCase names are found".
	re := '([A-Z][a-z]*[0-9]*)*' asRegex matchesPrefix: name capitalized; yourself.
	^ ((re subexpressions: 2) joinUsing: ' ') asLowercase capitalized.

]

{ #category : #selecting }
VZGlyph >> properties [
	| pragmas properties |
	
	pragmas := Pragma allNamed: #vzProperty: from: self class to: VZGlyph.
	properties := pragmas collect: [ :each |
		VZProperty ofPragma: each forObject: self ].

	^ properties
]

{ #category : #rendering }
VZGlyph >> renderOn: aVZRenderer [
	"Template method: do general rendering process, then call back to renderer."
	self beforeRenderOn: aVZRenderer.
	aVZRenderer initializeGlyphShape: self.
	self setPropertiesForGlyph.
	self afterRenderOn: aVZRenderer.
	^ shape
]

{ #category : #selecting }
VZGlyph >> select [
	self view select: self.

]

{ #category : #rendering }
VZGlyph >> setPropertiesForGlyph [
	^ self subclassResponsibility
]

{ #category : #accessing }
VZGlyph >> shape [
	<vzProperty: #categorical>
	^ shape
]

{ #category : #accessing }
VZGlyph >> shape: anObject [
	shape := anObject
]

{ #category : #rendering }
VZGlyph >> shapeForRoassal [
	^ self subclassResponsibility
]

{ #category : #selecting }
VZGlyph >> toggleSelection [
	self view toggleSelection: self.
]

{ #category : #selecting }
VZGlyph >> toggleSelectionAdditive [
	self view toggleSelectionAdditive: self
]

{ #category : #accessing }
VZGlyph >> view [
	^ view
]

{ #category : #accessing }
VZGlyph >> view: anObject [
	view := anObject
]
