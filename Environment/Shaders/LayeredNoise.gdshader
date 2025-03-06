shader_type spatial;

// From Voxel Tools API
uniform int u_transition_mask;

uniform sampler3D baseNoise;
uniform float baseNoiseScale = 1.0f;
uniform sampler3D secondaryNoise;
uniform float secondaryNoiseScale = 1.0f;
uniform sampler3D pileNoise;
uniform float pileNoiseScale = 1.0f;
uniform sampler3D ridgedNoise;
uniform float ridgedNoiseScale = 1.0f;
uniform vec3 stoneColor: source_color = vec3(0.2f, 0.25f, 0.25f);

float get_transvoxel_secondary_factor(int idata) {
	int transition_mask = u_transition_mask & 0xff;

	int cell_border_mask = idata & 63; // Which sides the cell is touching
	int vertex_border_mask = (idata >> 8) & 63; // Which sides the vertex is touching
	// If the vertex is near a side where there is a low-resolution neighbor,
	// move it to secondary position
	int m = transition_mask & cell_border_mask;
	float t = float(m != 0);
	// If the vertex lies on one or more sides, and at least one side has no low-resolution neighbor,
	// don't move the vertex.
	t *= float((vertex_border_mask & ~transition_mask) == 0);
	
	// Debugging
	//t *= 0.5 + 0.5 * sin(TIME * 4.0);
	//t *= 2.0;

	return t;
}

vec3 get_transvoxel_position(vec3 vertex_pos, vec4 fdata) {
	int idata = floatBitsToInt(fdata.a);

	// Move vertices to smooth transitions
	float secondary_factor = get_transvoxel_secondary_factor(idata);
	vec3 secondary_position = fdata.xyz;
	vec3 pos = mix(vertex_pos, secondary_position, secondary_factor);

	// If the mesh combines transitions and the vertex belongs to a transition,
	// when that transition isn't active we change the position of the vertices so
	// all triangles will be degenerate and won't be visible.
	// This is an alternative to rendering them separately,
	// which has less draw calls and less mesh resources to create in Godot.
	// Ideally I would tweak the index buffer like LOD does but Godot does not
	// expose anything to use it that way.
	int itransition = (idata >> 16) & 0xff; // Is the vertex on a transition mesh?
	float transition_cull = float(itransition == 0 || (itransition & u_transition_mask) != 0);
	pos *= transition_cull;

	return pos;
}

varying vec3 v_pos;

void vertex() {
	VERTEX = get_transvoxel_position(VERTEX, CUSTOM0);
    v_pos = VERTEX;
}

void fragment(){
	vec3 baseColor = texture(baseNoise, v_pos * baseNoiseScale).rgb;
	vec3 secondaryColor = texture(secondaryNoise, v_pos * secondaryNoiseScale).rgb;
	vec3 piles = texture(pileNoise, v_pos * pileNoiseScale).rgb;
	vec3 stones = texture(ridgedNoise, v_pos * ridgedNoiseScale).rgb;
	vec3 dirt = mix(baseColor, secondaryColor, 0.1);
	dirt = dirt * piles;
	ALBEDO = mix(stoneColor, dirt, stones);
	
	vec2 stoneNormal = vec2(dFdx(stones.r), dFdy(stones.r)) * 5.0;
	vec2 dirtNormal = vec2(dFdx(secondaryColor.r), dFdy(secondaryColor.r)) * 5.0;
	vec2 blackNormal = vec2(dFdx(piles.r), dFdy(piles.r)) * 15.0;
	vec2 normal = stoneNormal + dirtNormal + blackNormal;
	
    NORMAL = normalize(NORMAL - vec3(normal, 0.0));
	ROUGHNESS = 0.8;
}