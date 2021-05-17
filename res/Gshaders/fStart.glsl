vec4 color;

varying vec3 Position;
varying vec3 Normal;
varying vec2 texCoord;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;

uniform vec4 LightPosition, LightPosition2;

uniform float Shininess;

uniform sampler2D texture;
uniform float texScale;


void main()
{
	vec3 materialSpecularColor = vec3(1.0, 1.0, 1.0);
	
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
	
	float dirx = clamp(-LightPosition2.x, -3.0, 3.0);
    float diry = clamp(-LightPosition2.y, -3.0, 3.0);
    float dirz = clamp(-LightPosition2.z, -3.0, 3.0);
    
    vec4 LightDirection = vec4(dirx, diry, dirz, 0.0);
    
    vec3 L2 = normalize(-LightDirection).xyz; //to origin
    vec3 E2 = normalize(-pos);  //to Camera
    vec3 H2 = normalize(L2 + E2); //halfway vector
    
        //diffuse and specular terms
    float Kdif2 = max(dot(N, L2), 0.0);
    float Kspc2 = pow(max(dot(N, H2), 0.0), Shininess);
    
        //light 2 properties
    vec3 ambient2 = AmbientProduct;
    vec3 diffuse2 = DiffuseProduct * Kdif2;
    vec3 specular2 = SpecularProduct * Kspc2 * materialSpecularColor;

    vec3 intensity2 = (ambient2 + diffuse2 + specular2);
    
	
	vec3 globalAmbient = vec3(0.1,0.1,0.1);
	
	color.rgb = globalAmbient + 5.0 * (attenuation * ambient + attenuation * diffuse * attenuation * specular) + (intensity2);	
	
	color.a = 1.0;

	gl_FragColor = color * texture2D(texture, texCoord * 2.0 * texScale);
	
}
