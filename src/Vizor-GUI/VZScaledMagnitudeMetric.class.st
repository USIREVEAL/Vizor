"
I am a metric returning a scaled magnitude value for a node.
"
Class {
	#name : #VZScaledMagnitudeMetric,
	#superclass : #VZMetric,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #accessing }
VZScaledMagnitudeMetric class >> description [
	^ 'Double scaled magnitude of the model'
]

{ #category : #accessing }
VZScaledMagnitudeMetric class >> selectorOrBlock [
	^ [ :node | node model asInteger * 10 ]
]

{ #category : #accessing }
VZScaledMagnitudeMetric class >> shortName [
	^ #SCALMAG
]
