Class {
	#name : #VZMetricTest,
	#superclass : #VZTestCase,
	#instVars : [
		'node'
	],
	#category : #'Vizor-Tests-Core'
}

{ #category : #running }
VZMetricTest >> setUp [
	super setUp.
	
	node := VZNodeWithMetric new.

]

{ #category : #tests }
VZMetricTest >> testName [
	| metric |
	metric := VZExampleMetric.
	
	self assert: metric description equals: 'Example metric'.
]

{ #category : #tests }
VZMetricTest >> testSelector [
	| metric |
	metric := VZExampleMetric.
	
	self assert: metric selectorOrBlock equals: #computeExampleMetric.
]

{ #category : #tests }
VZMetricTest >> testShortName [
	| metric |
	metric := VZExampleMetric.
	
	self assert: metric shortName equals: 'EXMP'.
]

{ #category : #tests }
VZMetricTest >> testValue [
	| metric |
	metric := VZExampleMetric.
	
	self assert: (metric value: node) equals: 1.
]

{ #category : #tests }
VZMetricTest >> testValue2 [
	| metric |
	metric := VZExampleMetric.
	
	self assert: (metric value: node) equals: 1.
	self assert: (metric value: node) equals: 2.
]
