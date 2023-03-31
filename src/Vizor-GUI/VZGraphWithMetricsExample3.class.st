"
I am an example application using Vizor.
I open a simple Vizor window displaying a graph with position metrics associated to nodes.

I use VZScaledMagnitudeMetric for nodes x and y.
"
Class {
	#name : #VZGraphWithMetricsExample3,
	#superclass : #VZApplicationExample,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #'instance creation' }
VZGraphWithMetricsExample3 class >> open [
	<script>
	| view |
	view := VZViewBuilder new
		graph: VZGraph exampleForTests;
		viewSpec: self viewSpecs first;
		build.

	self new
		view: view;
		open.
]

{ #category : #accessing }
VZGraphWithMetricsExample3 class >> title [
	^ 'Simple graph with position metrics'
]

{ #category : #specs }
VZGraphWithMetricsExample3 class >> viewSpecs [
	^ { VZViewSpec new
		name: 'Position metric view';
		metricMappings: {
			VZNode -> {
				VZScaledMagnitudeMetric -> #x .
				VZScaledMagnitudeMetric -> #y .
				VZModelMetric -> #width .
				VZModelMetric -> #height .
			} .
		}.
	} asOrderedCollection
]
