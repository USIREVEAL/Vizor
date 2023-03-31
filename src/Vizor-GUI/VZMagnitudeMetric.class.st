"
I am a metric returning the magnitude value of a node.
"
Class {
	#name : #VZMagnitudeMetric,
	#superclass : #VZMetric,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #accessing }
VZMagnitudeMetric class >> description [
	^ 'Magnitude of the model'
]

{ #category : #accessing }
VZMagnitudeMetric class >> selectorOrBlock [
	^ [ :node | node model asInteger * 5 ]
]

{ #category : #accessing }
VZMagnitudeMetric class >> shortName [
	^ #MAG
]
