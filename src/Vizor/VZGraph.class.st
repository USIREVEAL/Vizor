"
I represent a graph.
I have a list of nodes and a list of edges.

Adding entities to me adds me as a reference graph in the entities.
"
Class {
	#name : #VZGraph,
	#superclass : #VZObject,
	#instVars : [
		'nodes',
		'edges'
	],
	#category : #'Vizor-Core'
}

{ #category : #examples }
VZGraph class >> exampleForTests [
	<script: 'self exampleForTests inspect'>
	| nodes edges |
	nodes := VZNode fromCollection: (1 to: 4).
	edges := {
		VZEdge between: nodes first and: nodes second withModel: '1->2' .
		VZEdge between: nodes first and: nodes third withModel: '1->3' . }.
		
	^ self new
		addNodes: nodes;
		addEdges: edges;
		yourself.
]

{ #category : #examples }
VZGraph class >> exampleWithMetrics [
	<script: 'self exampleWithMetrics inspect'>
	| nodes edges |
	nodes := ((1 to: 4) collect: [ :each | VZNodeWithIntModelMetric new model: each ]).
	edges := OrderedCollection new
		add: ((VZEdgeWithSumMetric between: nodes first and: nodes second) model: '1->2');
		add: ((VZEdgeWithSumMetric between: nodes first and: nodes fourth) model: '1->4');
		yourself.
		
	^ self new
		addNodes: nodes;
		addEdges: edges;
		yourself.
]

{ #category : #'instance creation' }
VZGraph class >> fromSelection: aVZSelection [
	| newGraph |
	newGraph := self new.
	newGraph addNodes: aVZSelection nodes.
	newGraph addEdges: aVZSelection edges.
	^ newGraph
]

{ #category : #'adding/removing' }
VZGraph >> addEdge: aVZEdge [ 
	aVZEdge graph: self.
	"Return the added edge."
	^ self edges add: aVZEdge.
]

{ #category : #'adding/removing' }
VZGraph >> addEdges: aCollectionOfVZEdge [
	"Return the added edges."
	^ aCollectionOfVZEdge collect: [ :each | self addEdge: each ].
]

{ #category : #'adding/removing' }
VZGraph >> addNode: aVZNode [ 
	aVZNode graph: self.
	"Return the added node."
	^ self nodes add: aVZNode.
]

{ #category : #'adding/removing' }
VZGraph >> addNodes: aCollectionOfVZNode [
	"Return the added collection"
	^ aCollectionOfVZNode collect: [ :each | self addNode: each ]
]

{ #category : #accessing }
VZGraph >> edges [
	^ edges ifNil: [ edges := OrderedCollection new ]
]

{ #category : #accessing }
VZGraph >> edges: anObject [
	edges := anObject
]

{ #category : #accessing }
VZGraph >> entities [
	^ self nodes , self edges
]

{ #category : #accessing }
VZGraph >> nodes [
	^ nodes ifNil: [ nodes := OrderedCollection new ]
]

{ #category : #accessing }
VZGraph >> nodes: anObject [
	nodes := anObject
]

{ #category : #removing }
VZGraph >> removeDanglingEdges [
	| dangling |
	dangling := self edges reject: [ :each | (nodes includes: each node1) and: [ nodes includes: each node2 ] ].
	self removeEdges: dangling.
]

{ #category : #'adding/removing' }
VZGraph >> removeEdge: aVZEdge [
	aVZEdge node1 ifNotNil: [
		aVZEdge node1 removeEdge: aVZEdge.
		aVZEdge node1: nil.
	].
	aVZEdge node2 ifNotNil: [
		aVZEdge node2 removeEdge: aVZEdge.
		aVZEdge node2: nil.
	].

	self edges remove: aVZEdge ifAbsent: [ nil ].
	aVZEdge graph: nil.

	"Return the removed edge."
	^ aVZEdge.
]

{ #category : #'adding/removing' }
VZGraph >> removeEdges: aCollectionOfVZEdge [
	"Return the removed edges."
	^ aCollectionOfVZEdge collect: [ :each | self removeEdge: each ].
]

{ #category : #'adding/removing' }
VZGraph >> removeNode: aVZNode [
	| copyEdges |
	copyEdges := aVZNode edges copy.
	self removeEdges: copyEdges.
	self nodes remove: aVZNode.
	aVZNode graph: nil.
	"Return the removed node."
	^ aVZNode.
]

{ #category : #'adding/removing' }
VZGraph >> removeNodes: aCollectionOfVZNode [
	"Return the removed collection"
	^ aCollectionOfVZNode collect: [ :each | self removeNode: each ]
]
