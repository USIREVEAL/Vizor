"
I am an example application using Vizor.
I open a simple Vizor window displaying a graph.
"
Class {
	#name : #VZSimpleGraphExample,
	#superclass : #VZApplicationExample,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #running }
VZSimpleGraphExample class >> open [
	<script>
	| view app anEdge |
	view := VZViewBuilder new
		graph: VZGraph exampleForTests;
		viewSpec: self viewSpecs first;
		build.

	app := self new
		view: view;
		open.

	anEdge := (app view findNodeByModel: 1) edges first.
	app view selectAllEntities: { anEdge . anEdge node1 . anEdge node2 } asOrderedCollection.

]

{ #category : #accessing }
VZSimpleGraphExample class >> title [
	^ 'Simple graph'
]
