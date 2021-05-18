vec4 color;

varying vec3 Position;
varying vec3 Normal;
varying vec2 texCoord;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;

uniform vec4 LightPosition;
uniform vec4 LightPosition2;

uniform float Shininess;

uniform sampler2D texture;
uniform float texScale;

void main()
{
	vec4 vpos = vec4(Position, 1.0);
	vec3 pos = (ModelView * vpos).xyz;
	vec3 N = normalize((ModelView * vec4(Normal, 0.0)).xyz);
	
	// Light One

	// Direction
	vec3 Lvec = LightPosition.xyz - pos;
	float lightDistance = length(Lvec);

	// Attenuation
	float attenuation = 1.0 / (1.0 + 1.0 * lightDistance + 1.0 * pow(lightDistance,2.0));

	vec3 L = normalize(Lvec);
	vec3 E = normalize(-pos);
	vec3 H = normalize(L + E);

	vec3 ambient = AmbientProduct; 
	float Kd = max(dot(L, N), 0.0);
	vec3 diffuse = Kd * DiffuseProduct;
	float Ks = pow(max(dot(N,H),0.0), Shininess);
	vec3 specular = Ks * SpecularProduct; 
	
	if (dot(L, N) < 0.0) {
		specular = vec3(0.0,0.0,0.0);
	}

	// Light Two
	float xDir, yDir, zDir;
	xDir = clamp(-LightPosition2.x, -3.0, 3.0);
	yDir = clamp(-LightPosition2.y, -3.0, 3.0);
	zDir = clamp(-LightPosition2.z, -3.0, 3.0);

	vec4 Direction = vec4(xDir, yDir, zDir, 0.0);

	vec3 L2 = normalize(-Direction).xyz;
	vec3 E2 = normalize(-pos);
	vec3 H2 = normalize(L2 + E2);

	vec3 ambient2 = AmbientProduct; 
	float Kd2 = max(dot(L2, N), 0.0);
	vec3 diffuse2 = Kd2 * DiffuseProduct;
	float Ks2 = pow(max(dot(N,H2),0.0), Shininess);
	vec3 specular2 = Ks2 * SpecularProduct; 
	
	if (dot(L2, N) < 0.0) {
		specular2 = vec3(0.0,0.0,0.0);
	}

	
	vec3 globalAmbient = vec3(0.1,0.1,0.1);

	vec3 colorLight1 = ambient + diffuse + specular;
	vec3 colorLight2 = ambient2 + diffuse2 + specular2;

	vec3 colorCombined = globalAmbient + colorLight1 * 5.0 + colorLight2 * 1.5;

	gl_FragColor = texture2D(texture, texCoord * 2.0 * texScale) * vec4(colorCombined, 1.0);
}