require './lib/term'
require './lib/word'
require './lib/definition'

def dictionary_menu
  puts "\n-Main Menu-\n"
  puts "Press 'n' to add a new term to the dictionary"
  puts "Press 'l' to list all words"
  puts "Press 's' to search for a word"
  puts "Press 'q' to quit\n\n"

  user_choice = gets.chomp.downcase

  case user_choice
  when 'n'
    add_term
  when 'l'
    list_all_words
  when 's'
    search
  when 'q'
    exit
  else
    puts "That is not a valid input. Please select again.\n"
    dictionary_menu
  end
end

def term_menu
  puts "\n-Term Menu-\n"
  puts "Enter word number to view definition(s), edit, or delete an entry."
  puts "Enter 'm' to return to the main menu."
  term_menu_choice = gets.chomp
    if term_menu_choice == 'm'
      dictionary_menu
    else
      current_term = Term.get_term(term_menu_choice.to_i - 1)
      term_edit_menu(current_term)
    end
end

def term_edit_menu(current_term)
  puts "\n-Term Edit Menu-\n"
  puts "#{current_term.word.word}: \n#{current_term.show_definitions}\n\n"
  puts "Press 'e' to edit the definition."
  puts "Press 'a' to add an additional definition."
  puts "Press 'd' to delete the term."
  puts "Press 'm' to return to main menu."
  term_edit_menu_choice = gets.chomp

  case term_edit_menu_choice
  when 'e'
    puts "Please enter the number for the definition to edit for #{current_term.word.word}: "
    definition_index = gets.chomp.to_i
    puts "Please enter an edited definition for #{current_term.word.word}: "
    new_definition = gets.chomp
    puts "Enter the language of the edited definition: "
    new_language = gets.chomp
    new_def = Definition.new(new_definition, new_language)
    current_term.edit_definition(new_def, definition_index-1)
    puts "New definition for #{current_term.word.word}: #{new_definition}"
    term_edit_menu(current_term)
  when 'a'
    puts "Please enter an additional definition for #{current_term.word.word}: "
    get_add_definition = gets.chomp
    puts "Please enter the language of this definition: "
    get_language = gets.chomp
    additional_definition = Definition.new(get_add_definition, get_language)
    current_term.add_definition(additional_definition)
    puts "#{get_add_definition} (#{get_language}) has been added to #{current_term.word.word}."
    term_edit_menu(current_term)
  when 'd'
    current_term.delete
    puts "#{current_term.word.word} has been deleted."
    list_all_words
  when 'm'
    dictionary_menu
  else
    puts "That is not a valid input."
    term_edit_menu(current_term)
  end
end

def add_term
  puts "\n-Add Term-\n"
  puts "Please enter a new word: "
  get_word = gets.chomp
  puts "Please specify the language for this word: "
  language = gets.chomp
  puts "Please enter a new definition: "
  get_definition = gets.chomp
  new_word = Word.new(get_word, language)
  new_definition = Definition.new(get_definition, language)
  new_term = Term.create(new_word, new_definition)
  puts "#{get_word} (#{language}) has been added. \n\n"
  dictionary_menu
end

def list_all_words
  puts "\n-All Words-\n"
  Term.list_words
  term_menu
end

def search
  puts "Please enter a word: "
  search_word = gets.chomp
  if Term.search(search_word) == []
    puts "Sorry, your word is not in this dictionary. Please add it!"
    dictionary_menu
  else
    found_word = Term.search(search_word)
    term_edit_menu(found_word)
  end
end

dictionary_menu
