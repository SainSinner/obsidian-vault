### Анаграммы
Две строки являются анаграммами, если они состоят из одного и того же множества символов с учетом числа повторов каждого из них
Доп. условие: обе строки из английских символов в lower-case.
Input: s = "anagram", t = "nagaram"
Output: true

Input: s = "ab", t = "ca"
Output: false

```python
# Ответ кандидата с сортировкой:

class Solution:  
    def isAnagram(self, s, t):  
        if len(s) != len(t):  
            return False  
  
        s_sorted = sorted(s)  
        t_sorted = sorted(t)  
  
        return s_sorted == t_sorted  
  
print(Solution().isAnagram("anagram", "nagaram"))  
print(Solution().isAnagram("ab", "ca"))

# Ответ кандидата с словарем:
# Этот более предпочтителен по памяти

class Solution:  
    def isAnagram(self, s, t):  
        if len(s) != len(t):  
            return False  
  
        count = {}  
  
        for char in s:  
            count[char] = count.get(char, 0) + 1  
  
        for char in t:  
            if char not in count:  
                return False  
            count[char] -= 1  
            if count[char] == 0:  
                del count[char]  
  
        return len(count) == 0  
  
print(Solution().isAnagram("anagram", "nagaram"))  
print(Solution().isAnagram("ab", "ca"))
```

### Пузырьковая сортировка

```python
def sorted_array(array):
    for i in range(len(array)):
        for j in range(0, len(array) - i - 1):
            if array[j] > array[j + 1]:
                array[j], array[j + 1] = array[j + 1], array[j]
    answer = array
    return answer


nums = [5, 2, 9, 1, 5, 6]
print(sorted_array(nums))
```

### Two Sum. Сумма двух
Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.

```python
class Solution(object):
    def twoSum(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: List[int]
        """
        for i in range(len(nums)):
            for j in range(i+1, len(nums)):
                if nums[i] + nums[j] == target:
                    answer = [i, j]
                    return answer

solution = Solution()
result = solution.twoSum([3,2,4], 6)
print(result)
```

### Fibonacci Number. Последовательность фибоначи.
The Fibonacci numbers, commonly denoted F(n) form a sequence, called the Fibonacci sequence, such that each number is the sum of the two preceding ones, starting from 0 and 1. That is,

F(0) = 0, F(1) = 1
F(n) = F(n - 1) + F(n - 2), for n > 1.
Given n, calculate F(n).

```python
from functools import lru_cache

class Solution(object):
    @lru_cache(maxsize=None)
    def fib(self, n):
        """
        :type n: int
        :rtype: int
        """
        if n == 0:
            return 0
        elif n == 1:
            return 1
        else:
            answer = self.fib(n - 1) + self.fib(n - 2)
            return answer

solution = Solution()
result = solution.fib(6)
print(result)
```

### Product of Array Except Self
Given an integer array nums, return an array answer such that answer[i] is equal to the product of all the elements of nums except nums[i].

The product of any prefix or suffix of nums is guaranteed to fit in a 32-bit integer.

You must write an algorithm that runs in O(n) time and without using the division operation.

```python
class Solution(object):
    def productExceptSelf(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        product = 0
        answer = []
        is_zero_array = False
        for i in range(len(nums)):
            if nums[i] != 0:
                if product == 0:
                    product = nums[i]
                else:
                    product = product * nums[i]
            else:
                is_zero_array = True
        for j in range(len(nums)):
            if is_zero_array == True and nums[j] != 0:
                answer.append(0)
            if is_zero_array == True and nums[j] == 0:
                answer.append(product)
            if is_zero_array == False and nums[j] != 0:
                answer.append(int(product/nums[j]))
        return answer

solution = Solution()
result = solution.productExceptSelf([0,0])
print(result)
```

### Longest Common Prefix. Самый длинный префикс для всех слов в листе.
GWrite a function to find the longest common prefix string amongst an array of strings.

If there is no common prefix, return an empty string "".
```python
class Solution(object):
    def longestCommonPrefix(self, strs):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        prefix = strs[0]
        for i in strs[1:]:
            while not i.startswith(prefix):
                prefix = prefix[:-1]
            if not prefix:
                return ""
        return prefix
solution = Solution()
result = solution.longestCommonPrefix(["flower","flow","flight"])
print(result)
#
# variable = ["flower","flow","flight"]
# print(variable[1][1])
```

### Longest palindromic. Самый длинный палиндром в строке.
Given a string s, return the longest palindromic substring in s.

```python
class Solution(object):
    def longestPalindrome(self, s):
        """
        :type s: str
        :rtype: str
        """
        def expand(left, right):
            while left >= 0 and right < len(s) and s[left] == s[right]:
                left -= 1
                right += 1
            return s[left + 1:right]

        longest = ""
        for i in range(len(s)):
            # Нечётный палиндром (центр один символ)
            p1 = expand(i, i)
            if len(p1) > len(longest):
                longest = p1

            # Чётный палиндром (центр между двумя символами)
            p2 = expand(i, i + 1)
            if len(p2) > len(longest):
                longest = p2

        return longest

solution = Solution()
result = solution.longestPalindrome("abbafabba")
print(result)
```

[3. Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters/)

Given a string `s`, find the length of the **longest** **substring** without duplicate characters.

**Example 1:**

**Input:** s = "abcabcbb"
**Output:** 3
**Explanation:** The answer is "abc", with the length of 3. Note that `"bca"` and `"cab"` are also correct answers.

**Example 2:**

**Input:** s = "bbbbb"
**Output:** 1
**Explanation:** The answer is "b", with the length of 1.

**Example 3:**

**Input:** s = "pwwkew"
**Output:** 3
**Explanation:** The answer is "wke", with the length of 3.
Notice that the answer must be a substring, "pwke" is a subsequence and not a substring.

```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:

        if len(s) == 0:
            return 0

        answer = []

        for i in range(len(s)):
            s_array = []
            for j in range(i, len(s)):
                if s[j] not in s_array:
                    s_array.append(s[j])
                else:
                    break
            flag = 0
            answer.append("".join(s_array))
            s_array.clear()

        return int(max(map(len, answer)))
```