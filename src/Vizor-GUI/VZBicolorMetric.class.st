"
I am an example metric returning 'Color red' for odd models, 'Color green' for even ones.
"
Class {
	#name : #VZBicolorMetric,
	#superclass : #VZMetric,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #accessing }
VZBicolorMetric class >> description [
	^ 'Two colors for odd and even models'
]

{ #category : #accessing }
VZBicolorMetric class >> selectorOrBlock [
	^ [ :node |
		node model asInteger odd
			ifTrue: [ Color red ]
			ifFalse: [ Color green ] ].
]

{ #category : #accessing }
VZBicolorMetric class >> shortName [
	^ #BICOLOR
]
