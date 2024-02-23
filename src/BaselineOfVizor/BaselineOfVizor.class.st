Class {
	#name : #BaselineOfVizor,
	#superclass : #BaselineOf,
	#category : #BaselineOfVizor
}

{ #category : #baselines }
BaselineOfVizor >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec for: #'pharo8.x' do: [
			"Pharo 8 Dependencies (Roassal)"
			self roassal3: spec.
		].
	
		self roassal3Exporters: spec.

		"Packages"
		spec
			package: 'Vizor';
			package: 'Vizor-GUI' with: [ spec requires: #('Vizor') ];
			package: 'Vizor-Tests' with: [ spec requires: #('Vizor') ];
			package: 'Vizor-GUI-Tests' with: [ spec requires: #('Vizor' 'Vizor-GUI' 'Vizor-Tests') ].
	].
]

{ #category : #baselines }
BaselineOfVizor >> roassal3: spec [
	spec
		baseline: 'Roassal3'
		with: [
			spec repository: 'github://ObjectProfile/Roassal3:v0.9.8'
		]
]

{ #category : #baselines }
BaselineOfVizor >> roassal3Exporters: spec [
	spec
		baseline: 'Roassal3Exporters'
		with: [
			spec repository: 'github://ObjectProfile/Roassal3Exporters'
		]
]
