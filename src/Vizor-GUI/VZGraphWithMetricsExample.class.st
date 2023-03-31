"
I am an example application using Vizor.
I open a simple Vizor window displaying a graph with dummy metrics associated to entities.

I use VZNodeWithIntModelMetric for nodes and VZEdgeWithSumMetric for edges.
I map metrics to width, height and color of my nodes.
I map a metric to the width of my edges.
"
Class {
	#name : #VZGraphWithMetricsExample,
	#superclass : #VZApplicationExample,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #running }
VZGraphWithMetricsExample class >> open [
	<script>
	| view app anEdge |
	view := VZViewBuilder new
		graph: VZGraph exampleWithMetrics;
		viewSpec: self viewSpecs first;
		build.

	app := self new
		view: view;
		open.

	anEdge := (app view findNodeByModel: 1) edges first.
	app view selectAllEntities: { anEdge . anEdge node1 . anEdge node2 } asOrderedCollection.
	
]

{ #category : #accessing }
VZGraphWithMetricsExample class >> title [
	^ 'Simple graph with color and size metrics'
]

{ #category : #running }
VZGraphWithMetricsExample class >> viewSpecs [
	^ { VZViewSpec new
		name: 'Metrics mapped view';
		layoutClass: RSCircleLayout;
		metricMappings: {
			VZNodeWithIntModelMetric -> {
				VZMagnitudeMetric -> #width .
				VZScaledMagnitudeMetric -> #height.
				VZBicolorMetric -> #color.
			} .
			VZEdgeWithSumMetric -> {
				VZSumNodesMetric -> #width.
			} .
		} .
	} asOrderedCollection
]
