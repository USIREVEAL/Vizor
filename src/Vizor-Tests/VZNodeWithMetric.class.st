"
I am an example subclass of VZNode defining its own metric for testing purposes.
"
Class {
	#name : #VZNodeWithMetric,
	#superclass : #VZNode,
	#category : #'Vizor-Tests-Base'
}

{ #category : #metrics }
VZNodeWithMetric class >> metricClasses [
	^ super metricClasses
		union: {
			VZExampleMetric .
		} asSet
]

{ #category : #metrics }
VZNodeWithMetric >> computeExampleMetric [
	| value |
	value := self metrics at: VZExampleMetric ifAbsent: [ ^ value := 1 ].
	^ value := value + 1.
]
