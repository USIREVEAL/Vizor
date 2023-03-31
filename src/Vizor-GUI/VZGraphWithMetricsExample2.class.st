"
I am an example application using Vizor.
I open a simple Vizor window displaying a graph with a degree metric associated to nodes.

I use VZDegreeMetric for nodes width and height.
"
Class {
	#name : #VZGraphWithMetricsExample2,
	#superclass : #VZApplicationExample,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #'instance creation' }
VZGraphWithMetricsExample2 class >> open [
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
VZGraphWithMetricsExample2 class >> title [
	^ 'Simple graph with size metrics'
]

{ #category : #specs }
VZGraphWithMetricsExample2 class >> viewSpecs [
	^ { VZViewSpec new
		name: 'Degree metric view';
		layoutClass: RSCircleLayout;
		metricMappings: {
			VZNode -> {
				VZNodeDegreeMetric -> #width .
				VZNodeDegreeMetric -> #height .
			} .
		}.
	} asOrderedCollection
]
