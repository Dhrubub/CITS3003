varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

uniform float texScale;

void main()
{
    gl_FragColor = color * texture2D( texture, texCoord * 2.0 * texScale);	// Where does the * 2 come from?
}
