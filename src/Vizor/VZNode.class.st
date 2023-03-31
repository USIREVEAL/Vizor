"
I am a node in a graph.
I know the edges I am connected to.

I have a width and a height.
"
Class {
	#name : #VZNode,
	#superclass : #VZEntity,
	#instVars : [
		'edges'
	],
	#category : #'Vizor-Core'
}

{ #category : #constants }
VZNode class >> defaultGlyphClass [
	^ VZNodeGlyph
]

{ #category : #'instance creation' }
VZNode class >> fromCollection: aCollection [ 
	^ aCollection collect: [ :each | self new model: each ].
]

{ #category : #metrics }
VZNode class >> metricClasses [
	^ super metricClasses union: { VZNodeDegreeMetric } asSet
]

{ #category : #'adding/removing' }
VZNode >> addEdge: aVZEdge [ 
	self edges add: aVZEdge.
]

{ #category : #accessing }
VZNode >> connectedNodes [
	^ self edges collect: [ :each |
		each node1 = self
			ifTrue: [ each node2 ]
			ifFalse: [ each node1 ] ].
]

{ #category : #accessing }
VZNode >> edges [
	^ edges ifNil: [ edges := OrderedCollection new ]
]

{ #category : #accessing }
VZNode >> edges: anObject [
	edges := anObject
]

{ #category : #accessing }
VZNode >> glyph [
	^ self class defaultGlyphFor: self
]

{ #category : #testing }
VZNode >> hasEdges [
	<vzProperty: #binary>
	^ self edges isNotEmpty.
]

{ #category : #testing }
VZNode >> isConnectedTo: aVZNode [
	^ self connectedNodes anySatisfy: [ :node | node = aVZNode ]
]

{ #category : #testing }
VZNode >> isNode [
	^ true.
]

{ #category : #accessing }
VZNode >> numberOfEdges [
	<vzProperty: #numerical>
	^ self edges size.
]

{ #category : #'adding/removing' }
VZNode >> removeEdge: aVZEdge [ 
	self edges remove: aVZEdge.
]

{ #category : #operations }
VZNode >> transitiveClosure [
	^ self transitiveClosureWithConnectedNodesBlock: #connectedNodes
]

{ #category : #operations }
VZNode >> transitiveClosureWithConnectedNodesBlock: aBlock [
	| closure visitQueue |
	closure := Set new.
	visitQueue := OrderedCollection with: self.
	[ visitQueue isNotEmpty ] whileTrue: [
		| node connectedNodes |
		node := visitQueue removeFirst.
		closure add: node.
		connectedNodes := aBlock value: node.
		visitQueue addAll: (connectedNodes reject: [ :each | closure includes: each ]). ].
	^ closure
]
