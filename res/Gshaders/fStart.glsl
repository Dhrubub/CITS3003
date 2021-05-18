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
uniform vec4 LightObj; // PART J. Location of light 1

// PART I. Light Object 2
uniform vec4 LightPosition2;
uniform vec3 LightColor2;
uniform float LightBrightness2;
uniform vec4 LightObj2; // PART J. Location of light 2

void main()
{
	vec3 materialSpecularColor = vec3(1.0, 1.0, 1.0);
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

	float Kd = max(dot(L, N), 0.0);
	float Ks = pow(max(dot(N, H),0.0), Shininess);
	
	vec3 ambient = AmbientProduct * (LightColor * LightBrightness); 
	vec3 diffuse = Kd * DiffuseProduct * (LightColor * LightBrightness);
	vec3 specular = Ks * SpecularProduct * LightBrightness; 
	
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

	float Kd2 = max(dot(L2, N), 0.0);
	float Ks2 = pow(max(dot(N, H2),0.0), Shininess);
	
	vec3 ambient2 = AmbientProduct * (LightColor2 * LightBrightness2); 
	vec3 diffuse2 = Kd2 * DiffuseProduct * (LightColor2 * LightBrightness2);
	vec3 specular2 = Ks2 * SpecularProduct * LightBrightness2 * vec3(1.0, 1.0, 1.0);
	
	// if (dot(L2, N) < 0.0) {
	// 	specular2 = vec3(0.0,0.0,0.0);
	// }
	float dotp = max(-dot(L2, N) * 0.7, 0.0);
	specular2 = vec3(dotp, dotp, dotp);

	
	vec3 globalAmbient = vec3(0.1,0.1,0.1);

	vec3 colorLight1 = attenuation * (ambient + diffuse + specular);
	vec3 colorLight2 = ambient2 + diffuse2 + specular2;

	vec3 colorCombined = globalAmbient + colorLight1 + colorLight2;

	gl_FragColor = texture2D(texture, texCoord * 2.0 * texScale) * vec4(colorCombined, 1.0);
	
    
 }
    
    
/*
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
uniform vec4 LightObj; // PART J. Location of light 1

// PART I. Light Object 2
uniform vec4 LightPosition2;
uniform vec3 LightColor2;
uniform float LightBrightness2;
uniform vec4 LightObj2; // PART J. Location of light 2

void main()
{
	vec4 vpos = vec4(Position, 1.0);
	
	vec3 pos = (ModelView * vpos).xyz;
	
	// The vector to the light from the vertex
    vec3 Lvec = LightPosition.xyz - pos;
    // The vector to the origin from the light 2
    vec3 Lvec2 = LightPosition2.xyz;
	
	    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize(Lvec);   // Direction to the light source
    vec3 L2 = normalize(Lvec2); // Direction to the origin from light 2
    vec3 E = normalize(-pos);   // Direction to the eye/camera
    vec3 H = normalize(L + E);  // Halfway vector
    vec3 H2 = normalize(L2 + E); // Halfway vector for light 2
    
	float lightDistance = length(Lvec);
	
	float attenuation = 1.0 / (1.0 + 1.0 * lightDistance + 0.25 * pow(lightDistance,2.0));

	vec3 N = normalize((ModelView * vec4(Normal, 0.0)).xyz);
	
    // Compute terms in the illumination equation
    vec3 ambient = (LightColor * LightBrightness) * AmbientProduct; // Light 1 ambient
    vec3 ambient2 = (LightColor2 * LightBrightness2) * AmbientProduct; // Light 2 ambient

    float Kd = max(dot(L, N), 0.0);
    vec3 diffuse = Kd * (LightColor * LightBrightness) * DiffuseProduct; // Light 1 diffuse
    float Kd2 = max(dot(L2, N), 0.0);
    vec3 diffuse2 = Kd2 * (LightColor2 * LightBrightness2) * DiffuseProduct; // Light 2 diffuse

    float Ks = pow(max(dot(N, H), 0.0), Shininess);
    vec3 specular = Ks * LightBrightness * SpecularProduct; // Light 1 specular
    float Ks2 = pow(max(dot(N, H2), 0.0), Shininess);
    vec3 specular2 = Ks2 * LightBrightness2 * SpecularProduct; // Light 2 specular

    if (dot(L, N) < 0.0) {
        specular = vec3(0.0, 0.0, 0.0);
    }

    if (dot(L2, N) < 0.0) {
        specular2 = vec3(0.0, 0.0, 0.0);
    }
	
	vec3 globalAmbient = vec3(0.1,0.1,0.1);
	

    color.rgb = globalAmbient + ((ambient + diffuse) * attenuation) + ambient2 + diffuse2;
    color.a = 1.0;
    
    gl_FragColor = (color * texture2D(texture, texCoord * 2.0 * texScale)) + vec4(specular * attenuation + specular2, 1.0);
    
 }
    
*/    
