"
I am an example application using Vizor.
I open a simple Vizor window displaying a graph with metrics mapped to devNull of node glyphs.
This is useful to have more metrics stored in an entity than those directly mapped to glyph properties.

Metrics are computed and stored in the entities but are visible only in the VZMetricsBar after hovering over an entity.
"
Class {
	#name : #VZGraphWithMetricsExample4,
	#superclass : #VZApplicationExample,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #'instance creation' }
VZGraphWithMetricsExample4 class >> open [
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
VZGraphWithMetricsExample4 class >> title [
	^ 'Simple graph with non-visual metrics'
]

{ #category : #specs }
VZGraphWithMetricsExample4 class >> viewSpecs [
	^ { VZViewSpec new
		name: 'No metric view';
		layoutClass: RSCircleLayout;
		metricMappings: {
			VZNode -> {
				VZScaledMagnitudeMetric -> #devNull .
				VZModelMetric -> #devNull .
			} .
		}.
	} asOrderedCollection
]
