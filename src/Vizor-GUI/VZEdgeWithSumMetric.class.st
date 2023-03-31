"
I am a simple edge mapping the sum of my connected nodes models values as integer to an EXMP metric.
"
Class {
	#name : #VZEdgeWithSumMetric,
	#superclass : #VZEdge,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #metrics }
VZEdgeWithSumMetric class >> metricClasses [
	^ super metricClasses union: { VZSumNodesMetric } asSet
]

{ #category : #metrics }
VZEdgeWithSumMetric >> sumOfConnectedNodes [
	^ (self node1 model asInteger + self node2 model asInteger) * 2
]
