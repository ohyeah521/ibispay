package util

import (
	"bufio"
	"encoding/hex"
	"io"
	"mime/multipart"
	"os"

	"github.com/thinkeridea/go-extend/exbytes"
	"golang.org/x/crypto/blake2b"
)

const filechunk = 65536

//SaveFileTo 保存文件到目录
func SaveFileTo(fh *multipart.FileHeader, destDirectory string) (int64, error) {
	src, err := fh.Open()
	if err != nil {
		return 0, err
	}
	defer src.Close()

	out, err := os.OpenFile(destDirectory, os.O_WRONLY|os.O_CREATE, os.FileMode(0666))
	if err != nil {
		return 0, err
	}
	defer out.Close()

	return io.Copy(out, src)
}

// GetHash256 计算文件的hash值，采用blake2b算法
func GetHash256(filename string) (string, error) {
	// Start hash
	hash, err := blake2b.New256(nil)
	if err != nil {
		return "", err
	}

	err = ReadFile(filename, func(chunk []byte) {
		io.WriteString(hash, exbytes.ToString(chunk))
	})
	if err != nil {
		return "", err
	}

	return hex.EncodeToString(hash.Sum(nil)), nil
}

//ReadReader 使用bufio代替ioutil.ReadAll
//bufio.NewReader(f)默认缓存4KB, 大于4KB用bufio.NewReaderSize(f,缓存大小)
func ReadReader(rd io.Reader, handle func([]byte)) error {
	bodyReader := bufio.NewReader(rd)
	for {
		block := make([]byte, 4096)
		n, err := bodyReader.Read(block)
		if err != nil && err != io.EOF {
			return err
		}
		if 0 == n {
			break
		}
		// Write to the buffer
		handle(block[0:n])
	}
	return nil
}

//ReadFile 读取大文件，小文件可以使用ioutil.ReadFile
func ReadFile(fileName string, handle func([]byte)) error {
	f, err := os.Open(fileName)
	if err != nil {
		return err
	}
	defer f.Close()

	r := bufio.NewReaderSize(f, filechunk)
	for {
		block := make([]byte, filechunk)

		switch n, err := r.Read(block); true {
		case n < 0:
			return err
		case n == 0: // EOF
			return nil
		case n > 0:
			handle(block[0:n])
		}
	}
}
