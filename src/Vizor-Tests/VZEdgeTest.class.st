"
A VZEdgeTest is a test class for testing the behavior of VZEdge
"
Class {
	#name : #VZEdgeTest,
	#superclass : #VZViewBasedTest,
	#category : #'Vizor-Tests-Core'
}

{ #category : #running }
VZEdgeTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
]

{ #category : #tests }
VZEdgeTest >> testCreation [
	| newEdge |
	newEdge := VZEdge between: node2 and: node3.
	
	self assert: newEdge node1 equals: node2.
	self assert: newEdge node2 equals: node3.
	self assert:( node2 edges includes: newEdge).
	self assert:( node3 edges includes: newEdge).
]

{ #category : #tests }
VZEdgeTest >> testGraph [
	self assert: edge1 graph isNotNil.
]

{ #category : #tests }
VZEdgeTest >> testNode1 [
	self assert: edge1 node1 equals: node1.
]

{ #category : #tests }
VZEdgeTest >> testNode2 [
	| edge |
	edge := node1 edges first.
	
	self assert: edge node2 equals: node2.
]
