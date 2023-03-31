"
I am an example metric that sums connected node models.
"
Class {
	#name : #VZSumNodesMetric,
	#superclass : #VZMetric,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #accessing }
VZSumNodesMetric class >> description [
	^ 	'Sum of models of connected nodes'
]

{ #category : #accessing }
VZSumNodesMetric class >> selectorOrBlock [
	^ 	#sumOfConnectedNodes
]

{ #category : #accessing }
VZSumNodesMetric class >> shortName [
	^ #SUMCONN
]
