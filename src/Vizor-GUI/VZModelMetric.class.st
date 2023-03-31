"
I am a metric returning the model value of a node.
I should be used on graphs that use numbers as models.
"
Class {
	#name : #VZModelMetric,
	#superclass : #VZMetric,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #accessing }
VZModelMetric class >> description [
	^ 'Value of the model'
]

{ #category : #accessing }
VZModelMetric class >> selectorOrBlock [
	^ #model
]

{ #category : #accessing }
VZModelMetric class >> shortName [
	^ #MODEL
]
