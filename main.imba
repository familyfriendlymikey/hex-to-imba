const p = console.log

def rgbToLab(rgb)
	let r = rgb[0] / 255
	let g = rgb[1] / 255
	let b = rgb[2] / 255
	let x
	let y
	let z

	r = (r > 0.04045) ? Math.pow((r + 0.055) / 1.055, 2.4) : r / 12.92
	g = (g > 0.04045) ? Math.pow((g + 0.055) / 1.055, 2.4) : g / 12.92
	b = (b > 0.04045) ? Math.pow((b + 0.055) / 1.055, 2.4) : b / 12.92

	x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047
	y = (r * 0.2126 + g * 0.7152 + b * 0.0722) / 1.00000
	z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883

	x = (x > 0.008856) ? Math.pow(x, 1/3) : (7.787 * x) + 16/116
	y = (y > 0.008856) ? Math.pow(y, 1/3) : (7.787 * y) + 16/116
	z = (z > 0.008856) ? Math.pow(z, 1/3) : (7.787 * z) + 16/116

	[(116 * y) - 16, 500 * (x - y), 200 * (y - z)]

def hexToRgb
	let result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec($1)
	return unless result
	[
		parseInt result[1], 16
		parseInt result[2], 16
		parseInt result[3], 16
	]

def labDeltaE
	let deltaL = $1[0] - $2[0]
	let deltaA = $1[1] - $2[1]
	let deltaB = $1[2] - $2[2]
	let c1 = Math.sqrt($1[1] * $1[1] + $1[2] * $1[2])
	let c2 = Math.sqrt($2[1] * $2[1] + $2[2] * $2[2])
	let deltaC = c1 - c2
	let deltaH = deltaA * deltaA + deltaB * deltaB - deltaC * deltaC
	deltaH = deltaH < 0 ? 0 : Math.sqrt(deltaH)
	let sc = 1.0 + 0.045 * c1
	let sh = 1.0 + 0.015 * c1
	let deltaLKlsl = deltaL / (1.0)
	let deltaCkcsc = deltaC / (sc)
	let deltaHkhsh = deltaH / (sh)
	let i = deltaLKlsl * deltaLKlsl + deltaCkcsc * deltaCkcsc + deltaHkhsh * deltaHkhsh
	i < 0 ? 0 : Math.sqrt(i)

def hexDeltaE
	labDeltaE
		rgbToLab(hexToRgb($1))
		rgbToLab(hexToRgb($2))

p hexDeltaE('61a6fa','61a6fb')
p hexDeltaE('61a6fa','ffffff')
p hexDeltaE('61a6fa','000000')
p hexDeltaE('ffffff','000000')
