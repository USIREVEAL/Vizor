"
I am a simple node mapping my model's value as integer to an EXMP metric.
"
Class {
	#name : #VZNodeWithIntModelMetric,
	#superclass : #VZNode,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #metrics }
VZNodeWithIntModelMetric class >> metricClasses [
	^ super metricClasses
		union: {
			VZBicolorMetric .
			VZMagnitudeMetric .
			VZScaledMagnitudeMetric .
		} asSet
]
