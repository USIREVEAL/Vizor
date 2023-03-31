"
I represent an abstract entity in a graph.
I have a model, a color, and I know whether I am hidden.
I also have a reference to the graph containing me (potentially nil).
"
Class {
	#name : #VZEntity,
	#superclass : #VZObject,
	#instVars : [
		'model',
		'metrics',
		'graph'
	],
	#category : #'Vizor-Core'
}

{ #category : #constants }
VZEntity class >> defaultGlyphClass [
	^ self subclassResponsibility
]

{ #category : #utility }
VZEntity class >> defaultGlyphFor: aVZEntity [
	^ self defaultGlyphClass of: aVZEntity
]

{ #category : #metrics }
VZEntity class >> metricClasses [
	^ Set new
]

{ #category : #metrics }
VZEntity >> defineMetrics [
	"This method should be overridden by subclasses to define their own metrics and add them to the metrics dictionary."
	^ self
]

{ #category : #interacting }
VZEntity >> fillContextMenu: aMenu inContext: aVZContext [
	aMenu addGroup: [ :group |
		group
			addItem: [ :item |
					item name: 'Inspect entity';
					action: [ self inspect ] ] ].
]

{ #category : #accessing }
VZEntity >> glyph [
	^ self subclassResponsibility
]

{ #category : #accessing }
VZEntity >> graph [
	^ graph
]

{ #category : #accessing }
VZEntity >> graph: anObject [
	graph := anObject
]

{ #category : #initialization }
VZEntity >> initialize [
	super initialize.
	self defineMetrics.
]

{ #category : #interacting }
VZEntity >> inspect [
	<vzContextMenu>
	^ super inspect.
]

{ #category : #testing }
VZEntity >> isEdge [
	<vzProperty: #binary>
	^ false.
]

{ #category : #testing }
VZEntity >> isNode [
	<vzProperty: #binary>
	^ false.
]

{ #category : #accessing }
VZEntity >> metrics [
	^ metrics ifNil: [ metrics := Dictionary new ]
]

{ #category : #accessing }
VZEntity >> metrics: aDictionaryOfVZMetrics [
	metrics := aDictionaryOfVZMetrics
]

{ #category : #accessing }
VZEntity >> model [
	^ model
]

{ #category : #accessing }
VZEntity >> model: anObject [
	model := anObject
]

{ #category : #printing }
VZEntity >> printOn: aStream [
	super printOn: aStream.
	self model ifNotNil: [ aStream << ' (' << self model asString << ')'. ].
]

{ #category : #accessing }
VZEntity >> properties [
	| pragmas properties |
	
	pragmas := Pragma allNamed: #vzProperty: from: self class to: VZEntity.
	properties := pragmas collect: [ :each |
		VZProperty ofPragma: each forObject: self ].

	^ properties
]
