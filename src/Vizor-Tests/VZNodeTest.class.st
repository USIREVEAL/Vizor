"
A VZNodeTest is a test class for testing the behavior of VZNode
"
Class {
	#name : #VZNodeTest,
	#superclass : #VZViewBasedTest,
	#category : #'Vizor-Tests-Core'
}

{ #category : #running }
VZNodeTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
]

{ #category : #tests }
VZNodeTest >> testConnectedNodes [
	self assert: node1 connectedNodes size equals: 2.
	self assertCollection: node1 connectedNodes hasSameElements: { node2 . node3 }.
]

{ #category : #tests }
VZNodeTest >> testConnectedNodes2 [
	self assert: node2 connectedNodes size equals: 1.
	self assertCollection: node2 connectedNodes hasSameElements: { node1 }.
]

{ #category : #tests }
VZNodeTest >> testConnectedNodes3 [
	self assert: node4 connectedNodes isEmpty.
]

{ #category : #tests }
VZNodeTest >> testEdges [
	self assert: node1 edges size equals: 2.
	self assert: node2 edges size equals: 1.
	self assert: node4 edges isEmpty.
]

{ #category : #tests }
VZNodeTest >> testFromCollection [
	| nodes |
	nodes := VZNode fromCollection: (1 to: 3).
	
	self assert: nodes first model equals: 1.
	self assert: nodes second model equals: 2.
	self assert: nodes third model equals: 3.

]

{ #category : #tests }
VZNodeTest >> testGraph [
	self assert: node1 graph isNotNil
]

{ #category : #test }
VZNodeTest >> testHasEdges [
	self assert: node1 hasEdges.
]

{ #category : #test }
VZNodeTest >> testHasEdges2 [
	self deny: node4 hasEdges.

]

{ #category : #test }
VZNodeTest >> testIsConnectedTo [
	self assert: (node1 isConnectedTo: node2).
	self assert: (node1 isConnectedTo: node3).
	self deny: (node2 isConnectedTo: node3).
	self deny: (node4 isConnectedTo: node1).
]

{ #category : #tests }
VZNodeTest >> testNumberOfEdges [
	self assert: node1 numberOfEdges equals: 2.
	self assert: node2 numberOfEdges equals: 1.
	self assert: node3 numberOfEdges equals: 1.

]

{ #category : #tests }
VZNodeTest >> testTransitiveClosure [
	| node1 node2 node3 expectedClosure |
	node1 := view findNodeByModel: 1.
	node2 := view findNodeByModel: 2.
	node3 := view findNodeByModel: 3.
	expectedClosure := { node1 . node2 . node3 }.
	
	self assertCollection: node1 transitiveClosure hasSameElements: expectedClosure.
	self assertCollection: node2 transitiveClosure hasSameElements: expectedClosure.
	self assertCollection: node3 transitiveClosure hasSameElements: expectedClosure.
]

{ #category : #tests }
VZNodeTest >> testTransitiveClosure2 [
	| expectedClosure |
	expectedClosure := { node4 }.
	
	self assertCollection: node4 transitiveClosure hasSameElements: expectedClosure.
]
