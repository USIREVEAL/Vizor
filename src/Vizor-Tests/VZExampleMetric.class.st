"
I am an example metric used for testing.
"
Class {
	#name : #VZExampleMetric,
	#superclass : #VZMetric,
	#category : #'Vizor-Tests-Base'
}

{ #category : #accessing }
VZExampleMetric class >> description [
	^ 'Example metric'

]

{ #category : #accessing }
VZExampleMetric class >> selectorOrBlock [
	^ #computeExampleMetric
]

{ #category : #accessing }
VZExampleMetric class >> shortName [
	^ 'EXMP'
]
