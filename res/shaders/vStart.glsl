attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;

varying vec3 N;
varying vec3 Lvec;
varying vec3 pos;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);
    
    //fN
    N = (ModelView*vec4(vNormal, 0.0)).xyz;

    // Transform vertex position into eye coordinates
    // fV
    pos = -(ModelView * vpos).xyz;


    // The vector to the light from the vertex   
    // fL 
    Lvec = LightPosition.xyz - (ModelView * vpos).xyz;

    gl_Position = Projection * ModelView * vpos;
    
    texCoord = vTexCoord;
}
