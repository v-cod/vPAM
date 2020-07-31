explode(string, delimiter, limit) {
	array = 0;
	result[array] = "";

	if (!isDefined(limit)) {
		limit = 0;
	}

	for (i = 0; i < string.size; i++) {
		if ((limit == 0 || array + 1 < limit) && string[i] == delimiter) {
			array++;
			result[array] = "";
		} else {
			result[array] += string[i];
		}
	}

	if (result.size > 1 && result[array] == "") {
		result[array] = undefined;
	}
	return result;
}

strip_spaces(str)
{
	str_dull = "";
	for (i = 0; i < str.size; i++) {
		if (str[i] == " ") {
			continue;
		}

		str_dull += str[i];
	}

	return str_dull;
}
