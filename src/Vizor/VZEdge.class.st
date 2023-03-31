"
I am an edge in a graph.
I know which two nodes I am connecting.
"
Class {
	#name : #VZEdge,
	#superclass : #VZEntity,
	#instVars : [
		'node1',
		'node2'
	],
	#category : #'Vizor-Core'
}

{ #category : #'instance creation' }
VZEdge class >> between: aVZNode1 and: aVZNode2 [ 
	| newEdge |
	newEdge := self new
		node1: aVZNode1;
		node2: aVZNode2.
	newEdge node1 addEdge: newEdge.
	newEdge node2 addEdge: newEdge.
	^ newEdge
]

{ #category : #'instance creation' }
VZEdge class >> between: aVZNode1 and: aVZNode2 withModel: anObject [
	| newEdge |
	newEdge := self new
		node1: aVZNode1;
		node2: aVZNode2;
		model: anObject;
		yourself.
	newEdge node1 addEdge: newEdge.
	newEdge node2 addEdge: newEdge.
	^ newEdge
]

{ #category : #constants }
VZEdge class >> defaultGlyphClass [
	^ VZEdgeGlyph
]

{ #category : #accessing }
VZEdge >> glyph [
	^ self class defaultGlyphFor: self
]

{ #category : #testing }
VZEdge >> isEdge [
	^ true.
]

{ #category : #accessing }
VZEdge >> node1 [
	^ node1
]

{ #category : #accessing }
VZEdge >> node1: aVZNode [ 
	node1 := aVZNode
]

{ #category : #accessing }
VZEdge >> node2 [
	^ node2
]

{ #category : #accessing }
VZEdge >> node2: aVZNode [
	node2 := aVZNode
]

{ #category : #'accessing-computed' }
VZEdge >> otherNodeOf: aVZNode [
	(self node1 = aVZNode) ifTrue: [ ^ self node2 ].
	(self node2 = aVZNode) ifTrue: [ ^ self node1 ].
	^ self error: (aVZNode printString) , ' is not connected to link ' , self printString.
]
