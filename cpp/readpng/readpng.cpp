#include <png.h>
#include <cstdio>
#include <stdexcept>

class PNG {
	private:
	png_struct *png;
	png_info *info;
	png_info *end_info;
	png_byte **data;

	public:

	PNG() : png(NULL), info(NULL), end_info(NULL) {
		data = NULL;
	}

	unsigned int height() const {
		return loaded() ? info->height : 0;
	}

	unsigned int width() const {
		return loaded() ? info->width : 0;
	}

	bool loaded() const {
		return data != NULL;
	}

	png_byte *operator[](unsigned int index) const throw (std::out_of_range) {
		if (index >= height()) {
			char msg[80];
			sprintf(msg, "Invalid row in PNG image: %u", index);
			throw std::out_of_range(msg);
		}
		return data[index];
	}

	void load(const char *filename) {
		FILE *fp = fopen(filename, "rb");

		if (!fp) {
			return;
		}

		// Read header bytes.
		const int number = 8;
		png_byte header[number];
		fread(header, 1, number, fp);

		// Verify this is a PNG.
		const bool is_png = !png_sig_cmp(header, 0, number);
		if (!is_png) {
			return;
		}

		// Allocate libpng structures.
		png = png_create_read_struct(PNG_LIBPNG_VER_STRING, (png_voidp)NULL, NULL, NULL);
		if (!png) {
			return;
		}

		info = png_create_info_struct(png);
		if (!info) {
			png_destroy_read_struct(&png, (png_infopp)NULL, (png_infopp)NULL);
			return;
		}

		end_info = png_create_info_struct(png);
		if (!end_info) {
			png_destroy_read_struct(&png, &info, (png_infopp)NULL);
			return;
		}

		// Read PNG into structures.
		png_init_io(png, fp);
		png_set_sig_bytes(png, number);
		png_read_png(png, info, PNG_TRANSFORM_EXPAND, NULL);
		data = png_get_rows(png, info);
	}

	void free() {
		png_destroy_read_struct(&png, &info, &end_info);
		data = NULL;
	}
};


int main(void)
{
	PNG png;
	png.load("verdana-14pt.png");

	if (!png.loaded()) {
		return 1;
	}

	try{

	for (unsigned int j = 0; j != png.height(); ++j) {
		for (unsigned int i = 0; i != 70; ++i) {
			int pos = i*4;
			png_byte *triplet = &png[j][pos];
			if (triplet[0] == 0xFF && triplet[1] == 0xFF && triplet[2] == 0xFF) {
				printf("*");
			} else if (triplet[0] > 0x50 && triplet[1] > 0x50 && triplet[2] > 0x50) {
				printf("o");
			} else {
				printf(".");
			}
		}
		printf("\n");
	}

	} catch (std::out_of_range e) {
		printf("[%s]\n", e.what());
	}

	png.free();

	return 0;
}
