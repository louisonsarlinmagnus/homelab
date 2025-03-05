# Titles

!!! note "Titles"

    === "Aspect"
        <h1>Big Title</h1>
            <h2>Medium Title</h2>
                <h3>Small Title</h3>
                    <h4>Small Sub Title</h4>
                        <h5>Very Small Title</h3>
                            <h6>Very Small Sub Title</h4>

    === "Markdown"
        ```md
        # Big Title
        ## Medium Title
        ### Small Title
        #### Small Sub Title
        ##### Very Small Title
        ###### Very Small Sub Title
        ```

    === "HTML"
        ````html
        <h1>Big Title</h1>
            <h2>Medium Title</h2>
                <h3>Small Title</h3>
                    <h4>Small Sub Title</h4>
                        <h5>Very Small Title</h3>
                            <h6>Very Small Sub Title</h4>
        ````

# Text formatting

!!! note "Text formatting"

    === "Aspect"
        This is some **bold text**  
        This is some *italic text*  
        This is some ***bold italic text***  
        This is some `in-line code`  
        This is some ^^underlined text^^  
        This is some ~~crossed out text~~  
        This is some ==highlighted text==

    === "Markdown"
        ```md
        This is some **bold text**  
        This is some *italic text*  
        This is some ***bold italic text***  
        This is some `inline code`  
        This is some ^^underlined text^^  
        This is some ~~crossed out text~~  
        This is some ==highlighted text==
        ```

# Horizontal separator

!!! note "Horizontal separator"

    === "Aspect"
        Some text
        ***
        Some text under the separator    
    === "Markdown"
        ```md
        ***
        ---
        ___
        ```

# Quote blocs

!!! note "Quote blocs"

    === "Aspect"
        > Never laugh at live dragons. 
        > J.R.R. Tolkien 
    === "Markdown"
        ```md
        > Never laugh at live dragons. 
        > J.R.R. Tolkien 
        ```

# Definition list

!!! note "Definition list"
    
    === "Aspect"
        Random
        : 1. Having no specific pattern, purpose, or objective: synonym: chance.
        : 2. Of or relating to a type of circumstance or event that is described by a probability distribution. 
    
    === "Markdown"
        ```md
        Random
        : 1. Having no specific pattern, purpose, or objective: synonym: chance.
        : 2. Of or relating to a type of circumstance or event that is described by a probability distribution. 
        ```

# Code formatting

## Inline code

!!! note "Inline code"

    === "Aspect"
        This is some `inline code`  
    === "Markdown"
        ```md
        This is some `inline code`  
        ```

## Code bloc

!!! note "Code bloc"

    === "Aspect"
        ```java hl_lines="1-2 5 7" linenums="1" title="randomJavaClass.java"
        public class HelloWorld {
          // This is a comment
          public static void main(String[] arg){
            // This is another one
            System.out.println("Hello world");
          }
        } 
        ```
    === "Markdown"
        ````md
        ```java hl_lines="1-2 5 7" linenums="1" title="randomJavaClass.java"
        public class HelloWorld {
          // This is a comment
          public static void main(String[] arg){
            // This is another one
            System.out.println("Hello world");
          }
        } 
        ```
        ````


# Lists

## Ordered list

!!! note "Ordered list"

    === "Aspect"
        1. First
        2. second
        3. Then (numbers don't matter)
        4. Finally, a last one

    === "Markdown"
        ```md
        1. First
        2. Second
        1. Then (numbers don't matter)
        4. Finally, a last one
        </a> #Stopping the list
        ```

    === "HTML"
        ````html
        <ol>
          <li>First</li>
          <li>second</li>
          <li>Then (numbers don't matter)</li>
          <li>Finally, a last one</li>
        </ol>
        ````

## Unordered list

!!! note "Unordered list"

    === "Aspect"
        - First
        - Second
            + Third

    === "Markdown"
        ```md
        - First
        - Second
            + Third
        ```

    === "HTML"
        ```html
        <ul>
            <li>First</li>
            <li>Second</li>
            <ul>
                <li>Third</li>
            </ul>
        </ul>
        ```

## Tasklist

!!! note "Tasklist"

    === "Aspect" 
        * [x] Lorem ipsum dolor sit amet, consectetur adipiscing elit
        * [ ] Vestibulum convallis sit amet nisi a tincidunt
            * [x] In hac habitasse platea dictumst
            * [x] In scelerisque nibh non dolor mollis congue sed et metus
            * [ ] Praesent sed risus massa
        * [ ] Aenean pretium efficitur erat, donec pharetra, ligula non scelerisque
    === "Code"
        ```md
        * [x] Lorem ipsum dolor sit amet, consectetur adipiscing elit
        * [ ] Vestibulum convallis sit amet nisi a tincidunt
            * [x] In hac habitasse platea dictumst
            * [x] In scelerisque nibh non dolor mollis congue sed et metus
            * [ ] Praesent sed risus massa
        * [ ] Aenean pretium efficitur erat, donec pharetra, ligula non scelerisque
        ```

# Emojis

[Extensive emoji list](https://gist.github.com/rxaviers/7360908)

| Emoji        | Aspect      |
|--:-----------|--:---------|
| `:alien:`    | :alien:    |
| `:yum:`      | :yum:      |
| `:confused:` | :confused: |
| `:smirk:`    | :smirk:    |
| `:kiss:`     | :kiss:     |
| `:frog:`     | :frog:     |
| `:fr:`       | :fr:       |
| `:gb:`       | :gb:       |
| `:tongue:`   | :tongue:   |
| `:computer:` | :computer: |

# Footnotes

!!! note

    === "Aspect"
        This is the first way[^1] to define a footnote.  
        This is some boring text.
        This is another way[^t] to define a footnote.  
        Another boring text

        [^1]: Using numbers
        [^t]: It's also possible to use characters
    === "Code"
        ```md
        This is the first way[^1] to define a footnote.  
        This is some boring text.
        This is another way[^t] to define a footnote.  
        Another boring text

        [^1]: Using numbers
        [^t]: It's also possible to use characters
        ```