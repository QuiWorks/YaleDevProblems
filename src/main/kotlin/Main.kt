// Test input.
private const val TEXT =
    "Given an arbitrary text document written in English, write a program that will generate a concordance, i.e. an\n" +
            "alphabetical list of all word occurrences, labeled with word frequencies. Bonus: label each word with the sentence\n" +
            "numbers in which each occurrence appeared."

// Regex for finding the separation between sentences.
private val SENTENCE_REGEX = Regex("(?<=[^A-Z].[.?]) +(?=[A-Z])")

// Regex for finding words and acronyms.
private val TOKEN_REGEX = Regex("((?:[a-zA-Z]\\.){2,}|\\w*)")

/**
 * A simple program for generating a concordance.
 */
fun main() {
    TEXT.split(SENTENCE_REGEX).withIndex()
        .map { (number, sentence) -> toOccurrences(number, sentence) }
        .flatMap { it }
        .fold<Occurrence, MutableMap<String, MutableList<Int>>>(mutableMapOf()) { map, occurrence ->
            if (map.containsKey(occurrence.word)) {
                map[occurrence.word]?.add(occurrence.sentenceNumber)
            } else {
                map[occurrence.word] = mutableListOf(occurrence.sentenceNumber)
            }
            map
        }
        .toSortedMap()
        .forEach { (word, occurrences) ->
            run {
                val total = occurrences.size
                println("$word {$total:$occurrences}")
            }
        }
}

/**
 * Function that maps a sentence to a list of [[Occurrence]]
 */
private fun toOccurrences(number: Int, sentence: String) =
    TOKEN_REGEX.findAll(sentence)
        .map { it.groupValues[1].lowercase() }
        .filter { it.isNotBlank() }
        .map { Occurrence(it, number + 1) }

/**
 * The occurrence of a word and the sentence it occurred in.
 */
data class Occurrence(val word: String, val sentenceNumber: Int)



