attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec3 Position;
varying vec3 Normal;
varying vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;

void main()
{
	vec4 vpos = vec4(vPosition, 1.0);
	
	gl_Position = Projection * ModelView * vpos;
	
	Position = vPosition;
	Normal = vNormal;
	texCoord = vTexCoord;
}
