"
I am a metric that computes the number of edges of a node.
"
Class {
	#name : #VZNodeDegreeMetric,
	#superclass : #VZMetric,
	#category : #'Vizor-Core'
}

{ #category : #accessing }
VZNodeDegreeMetric class >> description [
	^ 'The degree of a node.'
]

{ #category : #accessing }
VZNodeDegreeMetric class >> selectorOrBlock [
	^ [ :node | (node numberOfEdges + 1) * 10 ]
]

{ #category : #accessing }
VZNodeDegreeMetric class >> shortName [
	^ #DEGREE
]
