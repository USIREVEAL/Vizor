"
I am a generic metric class.

I define a standard way to apply and cache myself to a VZEntity.
This apply method is called `value:`
"
Class {
	#name : #VZMetric,
	#superclass : #VZObject,
	#category : #'Vizor-Core'
}

{ #category : #accessing }
VZMetric class >> description [
	^ self subclassResponsibility
]

{ #category : #accessing }
VZMetric class >> selectorOrBlock [
	^ self subclassResponsibility
]

{ #category : #accessing }
VZMetric class >> shortName [
	^ self subclassResponsibility
]

{ #category : #accessing }
VZMetric class >> value: aVZEntity [
	| v |
	v := self selectorOrBlock value: aVZEntity.
	aVZEntity metrics at: self put: v.
	^ v
]
