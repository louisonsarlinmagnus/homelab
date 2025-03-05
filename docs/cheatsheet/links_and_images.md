# Links and references

## External references

!!! note "External references"

    === "Aspect"
        [inline link](https://example.com/)  
        [Referencing with a number][1]  
        Using a [direct link].  
        [direct link]: https://example.com/  
        [1]: https://example.com/  

    === "Markdown"
        ```md
        [inline link](https://example.com/)  
        [Referencing with a number][1]  
        Using a [direct link].  
        [direct link]: https://example.com/  
        [1]: https://example.com/  
        ```


## Internal links

!!! note "Internal links"

    === "Aspect"
        [Reference to a file](../cheatsheet/links_and_images.md/)  
        [Reference to a title](#links-and-references)

    === "Markdown"
        ```md
        [Reference to a file](../cheatsheet/links_and_images.md/)  
        [Reference to a title](#links-and-references)
        ```

# Images

!!! note "Images"

    === "Aspect"
        Online image:  
        ![alt text](https://dummyimage.com/200x100/eee/aaa "Logo Title Text 1")

        Reference style:  
        ![alt text][logo]

        [logo]: https://dummyimage.com/200x100/eee/aaa "Logo Title Text 2"

    === "Markdown"
        ```md
        Online image:
        ![alt text](https://dummyimage.com/200x100/eee/aaa "Logo Title Text 1")

        Reference style: 
        ![alt text][logo]

        [logo]: https://dummyimage.com/200x100/eee/aaa "Logo Title Text 2"
        ```


!!! tip "Image alignment"
    It possible to align an image right or left using this:

    === "Aspect"
        ![Placeholder](https://dummyimage.com/200x100/eee/aaa){: align=right }
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et euismod
        nulla. Curabitur feugiat, tortor non consequat finibus, justo purus auctor
        massa, nec semper lorem quam in massa.

    === "Markdown"
        ```md
        ![Placeholder](https://dummyimage.com/200x100/eee/aaa){: align=right }
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et euismod
        nulla. Curabitur feugiat, tortor non consequat finibus, justo purus auctor
        massa, nec semper lorem quam in massa.
        ```

# Youtube video

!!! note "Videos YouTube"
    
    === "Aspect"
        [![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg)](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
    === "Markdown"
        ```md
        [![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg)](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
        ```
