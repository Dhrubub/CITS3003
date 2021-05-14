varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

//////////////////////////////////

varying vec3 N; //fn
varying vec3 Lvec; //fl
varying vec3 pos; //fv

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;

//////////////////////////////////
uniform sampler2D texture;
 
uniform float texScale;

void main()
{

    float lightDistance = length(Lvec);
	
    float attenuation = 1.0 / ( 5.0 + 9.0*lightDistance + 5.0*pow(lightDistance,2.0) );
    
	vec3 N = normalize(N);
	vec3 E = normalize(pos);
	vec3 L = normalize(Lvec);
	
	vec3 H = normalize(L + E);
	
	vec3 ambient = AmbientProduct;
	
	float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    
    
    gl_FragColor.rgb = globalAmbient  + attenuation*ambient + attenuation*diffuse + attenuation*specular; 
    gl_FragColor.a = 1.0;
	
    gl_FragColor = gl_FragColor * texture2D( texture, texCoord * texScale);	
}
