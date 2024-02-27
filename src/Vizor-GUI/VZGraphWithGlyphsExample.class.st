"
I am an example application using Vizor.
I open a simple Vizor window displaying a graph with special glyphs associated to entities.

I use VZCircleNodeGlyph for nodes and VZDashedEdgeGlyph for edges.
"
Class {
	#name : #VZGraphWithGlyphsExample,
	#superclass : #VZApplicationExample,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #'instance creation' }
VZGraphWithGlyphsExample class >> open [
<script>
	| view app anEdge |
	view := VZViewBuilder new
		graph: VZGraph exampleForTests;
		viewSpec: self viewSpecs first;
		build.
	app := self new.
	app view: view.
	app open.

	anEdge := (app view findNodeByModel: 1) edges first.
	app view selectAllEntities: { anEdge . anEdge node1 . anEdge node2 } asOrderedCollection.
	
]

{ #category : #accessing }
VZGraphWithGlyphsExample class >> title [
	^ 'Simple graph with custom glyphs'
]

{ #category : #specs }
VZGraphWithGlyphsExample class >> viewSpecs [
	^ { VZViewSpec new
		name: 'Circles and dashes';
		glyphMappings: {
			VZNode -> VZCircleNodeGlyph .
			VZEdge -> VZDashedEdgeGlyph . };
		layoutClass: RSClusterTreeLayout .
	} asOrderedCollection.
]
