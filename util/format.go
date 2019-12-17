package util

import (
	"bytes"
	"errors"
	"fmt"
	"html/template"
	"reflect"
	"regexp"
	"strings"
	"unicode"
	"unicode/utf8"
)

//修改自 https://github.com/leebenson/conform
//name+slug格式化: "34€8帅，Jo-s$%Ann_276 " -> "帅jo-sann276", " ~~ The Dude ~~" -> "the-dude", "**susan**" -> "susan", " hugh fearnley-whit" -> "hugh-fearnley-whit"

/* tags，逗号分隔多个tag，struct关键字format
trim
Trims leading and trailing spaces. Example: " string " -> "string"

ltrim
Trims leading spaces only. Example: " string " -> "string "

rtrim
Trims trailing spaces only. Example: " string " -> " string"

lower
Converts string to lowercase. Example: "STRING" -> "string"

upper
Converts string to uppercase. Example: "string" -> "STRING"

title
Converts string to Title Case, e.g. "this is a sentence" -> "This Is A Sentence"

camel
Converts to camel case via stringUp, Example provided by library: this is it => thisIsIt, this\_is\_it => thisIsIt, this-is-it => thisIsIt

snake
Converts to snake_case. Example: "CamelCase" -> "camel_case", "regular string" -> "regular_string" Special thanks to snaker for inspiration (credited in license)

slug
Turns strings into slugs. Example: "CamelCase" -> "camel-case", "blog title here" -> "blog-title-here"

ucfirst
Uppercases first character. Example: "all lower" -> "All lower"

name
Trims, strips numbers and special characters (except dashes and spaces separating names), converts multiple spaces and dashes to single characters, title cases multiple names. Example: "3493€848Jo-s$%£@Ann " -> "Jo-Ann", " ~~ The Dude ~~" -> "The Dude", "**susan**" -> "Susan", " hugh fearnley-whittingstall" -> "Hugh Fearnley-Whittingstall"

email
Trims and lowercases the string. Example: "UNSIGHTLY-EMAIL@EXamPLE.com " -> "unsightly-email@example.com"

num
Removes all non-numeric characters. Example: "the price is €30,38" -> "3038"

Note: The struct field will remain a string. No type conversion takes place.

!num
Removes all numbers. Example "39472349D34a34v69e8932747" -> "Dave"

alpha
Removes non-alpha unicode characters. Example: "!@£$%^&'()Hello 1234567890 World+[];\" -> "HelloWorld"

!alpha
Removes alpha unicode characters. Example: "Everything's here but the letters!" -> "' !"
*/

type x map[string]string

type sanitizer func(string) string

var sanitizers = map[string]sanitizer{}

var camelingRegex = regexp.MustCompile("[0-9\\pL]+")

var patterns = map[string]*regexp.Regexp{
	"numbers":    regexp.MustCompile("[0-9]"),
	"nonNumbers": regexp.MustCompile("[^0-9]"),
	"alpha":      regexp.MustCompile("[\\pL]"),
	"nonAlpha":   regexp.MustCompile("[^\\pL]"),
	"name":       regexp.MustCompile("[\\p{L}]([\\p{L}|[:space:]|\\-|\\d]*[\\p{L}|\\d|[:space:]])*"),
}

// a valid email will only have one "@", but let's treat the last "@" as the domain part separator
func emailLocalPart(s string) string {
	i := strings.LastIndex(s, "@")
	if i == -1 {
		return s
	}
	return s[0:i]
}

func emailDomainPart(s string) string {
	i := strings.LastIndex(s, "@")
	if i == -1 {
		return ""
	}
	return s[i+1:]
}

func email(s string) string {
	// According to rfc5321, "The local-part of a mailbox MUST BE treated as case sensitive"
	return emailLocalPart(s) + "@" + strings.ToLower(emailDomainPart(s))
}

func camelTo(s, sep string) string {
	var result string
	var words []string
	var lastPos int
	rs := []rune(s)

	for i := 0; i < len(rs); i++ {
		if i > 0 && unicode.IsUpper(rs[i]) {
			if initialism := startsWithInitialism(s[lastPos:]); initialism != "" {
				words = append(words, initialism)

				i += len(initialism) - 1
				lastPos = i
				continue
			}

			words = append(words, s[lastPos:i])
			lastPos = i
		}
	}

	// append the last word
	if s[lastPos:] != "" {
		words = append(words, s[lastPos:])
	}

	for k, word := range words {
		if k > 0 {
			result += sep
		}

		result += strings.ToLower(word)
	}

	return result
}

// startsWithInitialism returns the initialism if the given string begins with it
func startsWithInitialism(s string) string {
	var initialism string
	// the longest initialism is 5 char, the shortest 2
	for i := 1; i <= 5; i++ {
		if len(s) > i-1 && commonInitialisms[s[:i]] {
			initialism = s[:i]
		}
	}
	return initialism
}

// commonInitialisms, taken from
// https://github.com/golang/lint/blob/3d26dc39376c307203d3a221bada26816b3073cf/lint.go#L482
var commonInitialisms = map[string]bool{
	"API":   true,
	"ASCII": true,
	"CPU":   true,
	"CSS":   true,
	"DNS":   true,
	"EOF":   true,
	"GUID":  true,
	"HTML":  true,
	"HTTP":  true,
	"HTTPS": true,
	"ID":    true,
	"IP":    true,
	"JSON":  true,
	"LHS":   true,
	"QPS":   true,
	"RAM":   true,
	"RHS":   true,
	"RPC":   true,
	"SLA":   true,
	"SMTP":  true,
	"SSH":   true,
	"TLS":   true,
	"TTL":   true,
	"UI":    true,
	"UID":   true,
	"UUID":  true,
	"URI":   true,
	"URL":   true,
	"UTF8":  true,
	"VM":    true,
	"XML":   true,
}

func ucFirst(s string) string {
	if s == "" {
		return s
	}
	toRune, size := utf8.DecodeRuneInString(s)
	if !unicode.IsLower(toRune) {
		return s
	}
	buf := &bytes.Buffer{}
	buf.WriteRune(unicode.ToUpper(toRune))
	buf.WriteString(s[size:])
	return buf.String()
}

func onlyNumbers(s string) string {
	return patterns["nonNumbers"].ReplaceAllLiteralString(s, "")
}

func stripNumbers(s string) string {
	return patterns["numbers"].ReplaceAllLiteralString(s, "")
}

func onlyAlpha(s string) string {
	return patterns["nonAlpha"].ReplaceAllLiteralString(s, "")
}

func stripAlpha(s string) string {
	return patterns["alpha"].ReplaceAllLiteralString(s, "")
}

func onlyOne(s string, m []x) string {
	for _, v := range m {
		LogDebugAll(v)
		for f, r := range v {
			s = regexp.MustCompile(fmt.Sprintf("%s", f)).ReplaceAllLiteralString(s, r)
		}
	}
	return s
}

func formatName(s string) string {
	first := onlyOne(strings.ToLower(s), []x{
		{"[^\\pL\\s\\d-]": ""}, // cut off everything except [ alpha, hyphen, whitespace, 0-9]
		{"\\s{2,}": " "},       // trim more than two whitespaces to one
		{"-{2,}": "-"},         // trim more than two hyphens to one
		{"( )*-( )*": "-"},     // trim enclosing whitespaces around hyphen
	})
	return strings.Title(patterns["name"].FindString(first))
}

// Strings conforms strings based on reflection tags
func Strings(iface interface{}) error {
	ifv := reflect.ValueOf(iface)
	if ifv.Kind() != reflect.Ptr {
		return errors.New("Not a pointer")
	}
	ift := reflect.Indirect(ifv).Type()
	if ift.Kind() != reflect.Struct {
		return nil
	}
	for i := 0; i < ift.NumField(); i++ {
		v := ift.Field(i)
		el := reflect.Indirect(ifv.Elem().FieldByName(v.Name))
		switch el.Kind() {
		case reflect.Slice:
			if el.CanInterface() {
				if slice, ok := el.Interface().([]string); ok {
					for i, input := range slice {
						tags := v.Tag.Get("format")
						slice[i] = transformString(input, tags)
					}
				} else {
					val := reflect.ValueOf(el.Interface())
					for i := 0; i < val.Len(); i++ {
						Strings(val.Index(i).Addr().Interface())
					}
				}
			}
		case reflect.Map:
			if el.CanInterface() {
				val := reflect.ValueOf(el.Interface())
				for _, key := range val.MapKeys() {
					mapValue := val.MapIndex(key)
					mapValuePtr := reflect.New(mapValue.Type())
					mapValuePtr.Elem().Set(mapValue)
					if mapValuePtr.Elem().CanAddr() {
						Strings(mapValuePtr.Elem().Addr().Interface())
					}
					val.SetMapIndex(key, reflect.Indirect(mapValuePtr))
				}
			}
		case reflect.Struct:
			if el.CanAddr() && el.Addr().CanInterface() {
				Strings(el.Addr().Interface())
			}
		case reflect.String:
			if el.CanSet() {
				tags := v.Tag.Get("format")
				input := el.String()
				el.SetString(transformString(input, tags))
			}
		}
	}
	return nil
}

func camelCase(src string) string {
	byteSrc := []byte(src)
	chunks := camelingRegex.FindAll(byteSrc, -1)
	for idx, val := range chunks {
		if idx > 0 {
			chunks[idx] = bytes.Title(val)
		}
	}
	return string(bytes.Join(chunks, nil))
}

func transformString(input, tags string) string {
	if tags == "" {
		return input
	}
	for _, split := range strings.Split(tags, ",") {
		switch split {
		case "trim":
			input = strings.TrimSpace(input)
		case "ltrim":
			input = strings.TrimLeft(input, " ")
		case "rtrim":
			input = strings.TrimRight(input, " ")
		case "lower":
			input = strings.ToLower(input)
		case "upper":
			input = strings.ToUpper(input)
		case "name":
			input = formatName(input)
		case "title":
			input = strings.Title(input)
		case "camel":
			input = camelCase(input)
		case "snake":
			input = camelTo(camelCase(input), "_")
		case "slug":
			input = camelTo(camelCase(input), "-")
		case "ucfirst":
			input = ucFirst(input)
		case "email":
			input = email(strings.TrimSpace(input))
		case "num":
			input = onlyNumbers(input)
		case "!num":
			input = stripNumbers(input)
		case "alpha":
			input = onlyAlpha(input)
		case "!alpha":
			input = stripAlpha(input)
		case "!html":
			input = template.HTMLEscapeString(input)
		case "!js":
			input = template.JSEscapeString(input)
		default:
			if s, ok := sanitizers[split]; ok {
				input = s(input)
			}
		}
	}
	return input
}

// AddSanitizer associates a sanitizer with a key, which can be used in a Struct tag
func AddSanitizer(key string, s sanitizer) {
	sanitizers[key] = s
}
