#ifndef PPMIMAGE_H
#define PPMIMAGE_H

#include <fstream>
#include "math3d.h"

class PPMImage
{
public:
	PPMImage(const std::string& fileName, int width, int height);
	
	void DrawPixel(const Vector3f& color);
	
	virtual ~PPMImage();
protected:
private:
	PPMImage(PPMImage& other) {}
	void operator=(PPMImage& other) {}
	std::ofstream m_imageFile;
};

#endif // PPMIMAGE_H
