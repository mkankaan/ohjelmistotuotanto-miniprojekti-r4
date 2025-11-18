class UserInputError(Exception):
    pass

def validate_todo(content):
    if len(content) < 5:
        raise UserInputError("Todo content length must be greater than 4")

    if len(content) > 100:
          raise UserInputError("Todo content length must be smaller than 100")

def split_names(content):
    if content["author"].find(" and ") == -1:
        content["author"] = [content["author"]]
        return
    name_list = content["author"].split(" and ")
    content["author"] = name_list

def format_authors(author_list):
    formatted_string = ""

    for i in range(len(author_list)):
        formatted_string += author_list[i]
        print(author_list[i])

        if i < len(author_list)-1:
            formatted_string += " and "

    return formatted_string