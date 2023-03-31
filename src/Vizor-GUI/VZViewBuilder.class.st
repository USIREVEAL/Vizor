"
I am a simple builder that can be used to create a VZView to be opened in a VZMainWindow.

Provide me with a graph and a viewSpec to create a view (with the message build).
"
Class {
	#name : #VZViewBuilder,
	#superclass : #VZObject,
	#instVars : [
		'graph',
		'originalEntities',
		'visibleEntities',
		'viewSpec',
		'view'
	],
	#category : #'Vizor-GUI-Views'
}

{ #category : #constants }
VZViewBuilder class >> defaultViewClass [
	^ VZView
]

{ #category : #building }
VZViewBuilder >> build [
	| sortedEntities filteredEntities |
	view layoutClass: self viewSpec layoutClass.
	view entityClassToGlyphClass: self viewSpec glyphMappings.
	view entityToMetricMappingCache: self viewSpec metricMappings.
	view lastViewSpec: self viewSpec.
	view sortingBlock: self viewSpec sortingBlock.
	
	"Add entities only at the end, so the correct mappings are applied."
	filteredEntities := self filteredEntities: self visibleEntities.
	sortedEntities := self sortedEntities: filteredEntities.
	view addAll: sortedEntities.
	view originalEntities: self originalEntities.
	view graph: self graph.
	view name: self viewSpec name.
	
	^ view
]

{ #category : #accessing }
VZViewBuilder >> filteredEntities: aCollectionOfVZEntities [
	| entities filteredEntities nodes edges |
	self viewSpec entityClasses ifEmpty: [ ^ aCollectionOfVZEntities ].
	
	"Filter by class, remove filtered entities, then remove dangling edges."
	entities := aCollectionOfVZEntities select: [ :each | self viewSpec includesClass: each class ].
	filteredEntities := self viewSpec entityFilter value: entities.
	nodes := filteredEntities select: #isNode.
	edges := (filteredEntities select: #isEdge) select: [ :each |
		nodes includesAll: { each node1 . each node2 } ].
	
	^ (nodes , edges)
]

{ #category : #accessing }
VZViewBuilder >> graph [
	^ graph
]

{ #category : #accessing }
VZViewBuilder >> graph: anObject [
	graph := anObject
]

{ #category : #initialization }
VZViewBuilder >> initialize [
	super initialize.
	view := self class defaultViewClass new.
	viewSpec := VZViewSpec new.
]

{ #category : #accessing }
VZViewBuilder >> originalEntities [
	^ originalEntities ifNil: [ originalEntities := self graph entities ]
]

{ #category : #accessing }
VZViewBuilder >> originalEntities: aCollectionOfVZEntities [
	originalEntities := aCollectionOfVZEntities
]

{ #category : #accessing }
VZViewBuilder >> sortedEntities: aCollectionOfVZEntities [
	self viewSpec sortingBlock
		ifNil: [ ^ aCollectionOfVZEntities ]
		ifNotNil: [ ^ self viewSpec sortingBlock value: aCollectionOfVZEntities ].
]

{ #category : #accessing }
VZViewBuilder >> viewSpec [
	^ viewSpec
]

{ #category : #accessing }
VZViewBuilder >> viewSpec: aVZViewSpec [
	viewSpec := aVZViewSpec
]

{ #category : #accessing }
VZViewBuilder >> visibleEntities [
	^ visibleEntities ifNil: [ visibleEntities := self originalEntities ]
]

{ #category : #accessing }
VZViewBuilder >> visibleEntities: anObject [
	visibleEntities := anObject
]
