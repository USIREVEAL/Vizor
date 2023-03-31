Class {
	#name : #VZViewBasedTest,
	#superclass : #VZTestCase,
	#instVars : [
		'view',
		'node1',
		'node2',
		'node3',
		'node4',
		'edge1',
		'edge2'
	],
	#category : #'Vizor-Tests-Core'
}

{ #category : #running }
VZViewBasedTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	view := VZView exampleForTests.

	node1 := view findNodeByModel: 1.
	node2 := view findNodeByModel: 2.
	node3 := view findNodeByModel: 3.
	node4 := view findNodeByModel: 4.
	edge1 := node1 edges first.
	edge2 := node1 edges second.
]
