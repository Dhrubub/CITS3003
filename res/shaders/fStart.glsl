vec4 color;

varying vec3 Position;
varying vec3 Normal;
varying vec2 texCoord;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;

uniform vec4 LightPosition;

uniform float Shininess;

uniform sampler2D texture;
uniform float texScale;

void main()
{
	vec4 vpos = vec4(Position, 1.0);
	
	vec3 pos = (ModelView * vpos).xyz;
	
	vec3 Lvec = LightPosition.xyz - pos;
	
	float lightDistance = length(Lvec);
	
	float attenuation = 1.0 / (1.0 + 1.0 * lightDistance + 0.25 * pow(lightDistance,2.0));
	
	vec3 L = normalize(Lvec);
	vec3 E = normalize(-pos);
	vec3 H = normalize(L + E);

	vec3 N = normalize((ModelView * vec4(Normal, 0.0)).xyz);
	
	vec3 ambient = AmbientProduct; 
	
	float Kd = max(dot(L, N), 0.0);
	
	vec3 diffuse = Kd * DiffuseProduct;
	
	float Ks = pow(max(dot(N,H),0.0), Shininess);
	
	vec3 specular = Ks * SpecularProduct; 
	
	if (dot(L, N) < 0.0) {
		specular = vec3(0.0,0.0,0.0);
	}
	
	vec3 globalAmbient = vec3(0.1,0.1,0.1);
	
	color.rgb = globalAmbient + attenuation * ambient + attenuation * diffuse;
	
	color.a = 1.0;

	gl_FragColor = color * texture2D(texture, texCoord * 2.0 * texScale) + vec4(attenuation * specular, 1.0);
}


/*
vec4 color;

varying vec3 Position;
varying vec3 Normal;
varying vec2 texCoord;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;

uniform vec4 LightPosition;
uniform vec3 LightColor;
uniform float LightBrightness;

uniform float Shininess;

uniform sampler2D texture;
uniform float texScale;

void main()
{
	vec4 vpos = vec4(Position, 1.0);
	
	vec3 pos = (ModelView * vpos).xyz;
	
	vec3 Lvec = LightPosition.xyz - pos;
	
	float lightDistance = length(Lvec);
	
	float attenuation = 1.0 / (1.0 + 1.0 * lightDistance + 0.25 * pow(lightDistance,2.0));
	
	vec3 L = normalize(Lvec);
	vec3 E = normalize(-pos);
	vec3 H = normalize(L + E);

	vec3 N = normalize((ModelView * vec4(Normal, 0.0)).xyz);
	
	vec3 ambient = (LightColor * LightBrightness) * AmbientProduct; // Light 1 ambient
	
	float Kd = max(dot(L, N), 0.0);
	
	vec3 diffuse = Kd * (LightColor * LightBrightness) * DiffuseProduct;
	
	float Ks = pow(max(dot(N,H),0.0), Shininess);
	
	vec3 specular = Ks * LightBrightness * SpecularProduct; // Light 1 specular
	
	if (dot(L, N) < 0.0) {
		specular = vec3(0.0,0.0,0.0);
	}
	
	vec3 globalAmbient = vec3(0.1,0.1,0.1);
	
	color.rgb = globalAmbient + attenuation * ambient + attenuation * diffuse;
	
	color.a = 1.0;

	gl_FragColor = color * texture2D(texture, texCoord * 2.0 * texScale) + vec4(attenuation * specular, 1.0);
}
*/
