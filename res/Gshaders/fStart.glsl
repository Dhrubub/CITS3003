vec4 color;

varying vec3 Position;
varying vec3 Normal;
varying vec2 texCoord;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;

uniform float Shininess;

uniform sampler2D texture;
uniform float texScale;

// Light Object 1
uniform vec4 LightPosition;
uniform vec3 LightColor;
uniform float LightBrightness;
uniform vec4 LightObj; // EDIT: PART J Location of light 1

// PART I. Light Object 2
uniform vec4 LightPosition2;
uniform vec3 LightColor2;
uniform float LightBrightness2;
uniform vec4 LightObj2; // EDIT: PART J Location of light 2

// PART I. Light Object 3
uniform vec4 LightPosition3;
uniform vec3 LightColor3;
uniform float LightBrightness3;
uniform vec4 LightObj3; // EDIT: PART J Location of light 3

uniform float spotlightDistance;
uniform float spotlightX;
uniform float spotlightZ;

void main()
{
	vec3 materialSpecularColor = vec3(1.0, 1.0, 1.0);
	vec4 vpos = vec4(Position, 1.0);
	vec3 pos = (ModelView * vpos).xyz;
	vec3 N = normalize((ModelView * vec4(Normal, 0.0)).xyz);
	
	// Light One ------------------------------------------------------------------------
	// Direction
	vec3 Lvec = LightPosition.xyz - pos;
	float lightDistance = length(Lvec);

	// Attenuation
	float attenuation = 1.0 / (1.0 + 1.0 * lightDistance + 1.0 * pow(lightDistance,2.0));

	vec3 L = normalize(Lvec);
	vec3 E = normalize(-pos);
	vec3 H = normalize(L + E);

	float Kd = max(dot(L, N), 0.0);
	float Ks = pow(max(dot(N, H),0.0), Shininess);
	
	vec3 ambient = AmbientProduct * (LightColor * LightBrightness); 
	vec3 diffuse = Kd * DiffuseProduct * (LightColor * LightBrightness);
	vec3 specular = Ks * SpecularProduct * LightBrightness * vec3(1.0, 1.0, 1.0);; 
	
	if (dot(L, N) < 0.0) {
		specular = vec3(0.0,0.0,0.0);
	}

	// Light Two ------------------------------------------------------------------------
	// Direction
	float xDir, yDir, zDir;
	xDir = clamp(-LightPosition2.x, -3.0, 3.0);
	yDir = clamp(-LightPosition2.y, -3.0, 3.0);
	zDir = clamp(-LightPosition2.z, -3.0, 3.0);

	vec4 Direction = vec4(xDir, yDir, zDir, 0.0);

	vec3 L2 = normalize(-Direction).xyz;
	vec3 E2 = normalize(-pos);
	vec3 H2 = normalize(L2 + E2);

	float Kd2 = max(dot(L2, N), 0.0);
	float Ks2 = pow(max(dot(N, H2),0.0), Shininess);
	
	vec3 ambient2 = AmbientProduct * (LightColor2 * LightBrightness2); 
	vec3 diffuse2 = Kd2 * DiffuseProduct * (LightColor2 * LightBrightness2);
	vec3 specular2 = Ks2 * SpecularProduct * LightBrightness2 * vec3(1.0, 1.0, 1.0);
	
	if (dot(L2, N) < 0.0) {
		specular2 = vec3(0.0,0.0,0.0);
	}

	// Light Three ------------------------------------------------------------------------
	// Direction
	vec3 colorLight3 = vec3(0.0, 0.0, 0.0);
	vec3 Lvec3 = LightPosition3.xyz - pos -spotlightDistance;

	float theta = dot(N + vec3(spotlightX, 0, spotlightZ), normalize(-Lvec3));
	



	if (theta > 0.75) {  
		vec3 L3 = normalize(Lvec3);
		vec3 E3 = normalize(-pos);
		vec3 H3 = normalize(L3 + E3);
		float Kd3 = max(dot(L3, N), 0.0);
		float Ks3 = pow(max(dot(N, H3),0.0), Shininess);
		float lightDistance3 = length(Lvec3);

		vec3 ambient3 = AmbientProduct * (LightColor3 * LightBrightness3); 
		vec3 diffuse3 = Kd3 * DiffuseProduct * (LightColor3 * LightBrightness3);
		vec3 specular3 = Ks3 * SpecularProduct * LightBrightness3 * vec3(1.0, 1.0, 1.0);; 

		float attenuation3 = 1.0 / (1.0 + 1.0 * lightDistance3 + 1.0 * pow(lightDistance3,2.0));
	
		if (dot(L3, N) < 0.0) {
			specular3 = vec3(0.0,0.0,0.0);
		}
		colorLight3 = attenuation3 * (ambient3 + diffuse3 + specular3);
	}

	vec3 globalAmbient = vec3(0.1,0.1,0.1);

	vec3 colorLight1 = attenuation * (ambient + diffuse + specular);
	vec3 colorLight2 = ambient2 + diffuse2 + specular2;
	
	vec3 colorCombined = globalAmbient + colorLight1 + colorLight2 + colorLight3;

	gl_FragColor = texture2D(texture, texCoord * 2.0 * texScale) * vec4(colorCombined, 1.0);
	
 }