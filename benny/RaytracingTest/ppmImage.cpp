#include "ppmImage.h"
#include <sstream>

PPMImage::PPMImage(const std::string& fileName, int width, int height)
{
	m_imageFile.open(fileName.c_str());
		
	std::ostringstream convert;
		
	convert << "P6 " << width << " " << height << " 255 ";
		
	m_imageFile << convert.str();
}

PPMImage::~PPMImage()
{
	m_imageFile.close();
}

void PPMImage::DrawPixel(const Vector3f& color)
{
	Vector3f trueColor = color * 255;
	
	char r = (char)((int)trueColor.GetX());
	char g = (char)((int)trueColor.GetY());
	char b = (char)((int)trueColor.GetZ());
	
	m_imageFile << r << g << b;
}

